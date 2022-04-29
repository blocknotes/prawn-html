# frozen_string_literal: true

module PrawnHtml
  class DocumentRenderer
    NEW_LINE = { text: "\n" }.freeze
    SPACE = { text: ' ' }.freeze

    # Init the DocumentRenderer
    #
    # @param pdf [PdfWrapper] target PDF wrapper
    def initialize(pdf)
      @buffer = []
      @context = Context.new
      @last_margin = 0
      @last_text = ''
      @last_tag_open = false
      @pdf = pdf
    end

    # On tag close callback
    #
    # @param element [Tag] closing element wrapper
    def on_tag_close(element)
      render_if_needed(element)
      apply_tag_close_styles(element)
      context.remove_last
      @last_tag_open = false
      @last_text = ''
    end

    # On tag open callback
    #
    # @param tag_name [String] the tag name of the opening element
    # @param attributes [Hash] an hash of the element attributes
    # @param element_styles [String] document styles to apply to the element
    #
    # @return [Tag] the opening element wrapper
    def on_tag_open(tag_name, attributes:, element_styles: '')
      tag_class = Tag.class_for(tag_name)
      return unless tag_class

      options = { width: pdf.page_width, height: pdf.page_height }
      tag_class.new(tag_name, attributes: attributes, options: options).tap do |element|
        setup_element(element, element_styles: element_styles)
        @last_tag_open = true
      end
    end

    # On text node callback
    #
    # @param content [String] the text node content
    #
    # @return [NilClass] nil value (=> no element)
    def on_text_node(content)
      return if context.previous_tag&.block? && content.match?(/\A\s*\Z/)

      text = prepare_text(content)
      buffer << context.merged_styles.merge(text: text) unless text.empty?
      context.last_text_node = true
      nil
    end

    # Render the buffer content to the PDF document
    def render
      return if buffer.empty?

      output_content(buffer.dup, context.block_styles)
      buffer.clear
      @last_margin = 0
    end

    alias_method :flush, :render

    private

    attr_reader :buffer, :context, :last_margin, :pdf

    def setup_element(element, element_styles:)
      render_if_needed(element)
      context.add(element)
      element.process_styles(element_styles: element_styles)
      apply_tag_open_styles(element)
      element.custom_render(pdf, context) if element.respond_to?(:custom_render)
    end

    def render_if_needed(element)
      render_needed = element&.block? && buffer.any? && buffer.last != NEW_LINE
      return false unless render_needed

      render
      true
    end

    def apply_tag_close_styles(element)
      tag_styles = element.tag_close_styles
      @last_margin = tag_styles[:margin_bottom].to_f
      pdf.advance_cursor(last_margin + tag_styles[:padding_bottom].to_f)
      pdf.start_new_page if tag_styles[:break_after]
    end

    def apply_tag_open_styles(element)
      tag_styles = element.tag_open_styles
      move_down = (tag_styles[:margin_top].to_f - last_margin) + tag_styles[:padding_top].to_f
      pdf.advance_cursor(move_down) if move_down > 0
      pdf.start_new_page if tag_styles[:break_before]
    end

    def prepare_text(content)
      before_content = context.before_content
      text = before_content ? ::Oga::HTML::Entities.decode(before_content) : ''
      return (@last_text = text + content) if context.white_space_pre?

      content = content.lstrip if @last_text[-1] == ' ' || @last_tag_open
      text += content.tr("\n", ' ').squeeze(' ')
      @last_text = text
    end

    def output_content(buffer, block_styles)
      apply_callbacks(buffer)
      left_indent = block_styles[:margin_left].to_f + block_styles[:padding_left].to_f
      options = block_styles.slice(:align, :indent_paragraphs, :leading, :mode, :padding_left)
      options[:leading] = adjust_leading(buffer, options[:leading])
      pdf.puts(buffer, options, bounding_box: bounds(buffer, options, block_styles), left_indent: left_indent)
    end

    def apply_callbacks(buffer)
      buffer.select { |item| item[:callback] }.each do |item|
        callback, arg = item[:callback]
        callback_class = Tag::CALLBACKS[callback]
        item[:callback] = callback_class.new(pdf, arg)
      end
    end

    def adjust_leading(buffer, leading)
      return leading if leading

      leadings = buffer.map do |item|
        (item[:size] || Context::DEFAULT_STYLES[:size]) * (ADJUST_LEADING[item[:font]] || ADJUST_LEADING[nil])
      end
      leadings.max.round(4)
    end

    def bounds(buffer, options, block_styles)
      return unless block_styles[:position] == :absolute

      x = if block_styles.include?(:right)
            x1 = pdf.calc_buffer_width(buffer) + block_styles[:right]
            x1 < pdf.page_width ? (pdf.page_width - x1) : 0
          else
            block_styles[:left] || 0
          end
      y = if block_styles.include?(:bottom)
            pdf.calc_buffer_height(buffer, options) + block_styles[:bottom]
          else
            pdf.page_height - (block_styles[:top] || 0)
          end

      [[x, y], { width: pdf.page_width - x }]
    end
  end
end
