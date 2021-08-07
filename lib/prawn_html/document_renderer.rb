# frozen_string_literal: true

module PrawnHtml
  class DocumentRenderer
    NEW_LINE = { text: "\n" }.freeze
    SPACE = { text: ' ' }.freeze
    TAG_CLASSES = [Tags::Div].freeze

    # Init the DocumentRenderer
    #
    # @param pdf [Prawn::Document] target Prawn PDF document
    def initialize(pdf)
      @buffer = []
      @context = Context.new
      @doc_styles = {}
      @pdf = pdf
    end

    # Assigns the document styles
    #
    # @param styles [Hash] styles hash with CSS selectors as keys and rules as values
    def assign_document_styles(styles)
      @doc_styles = styles.transform_values do |style_rules|
        Attributes.new(style: style_rules).styles
      end
    end

    # On tag close callback
    #
    # @param element [Tags::Base] closing element wrapper
    def on_tag_close(element)
      render_if_needed(element)
      apply_post_styles(element&.post_styles)
      context.last_text_node = false
      context.pop
    end

    # On tag open callback
    #
    # @param tag [String] the tag name of the opening element
    # @param attributes [Hash] an hash of the element attributes
    #
    # @return [Tags::Base] the opening element wrapper
    def on_tag_open(tag, attributes)
      tag_class = tag_classes[tag]
      return unless tag_class

      tag_class.new(tag, attributes).tap do |element|
        setup_element(element)
      end
    end

    # On text node callback
    #
    # @param content [String] the text node content
    #
    # @return [NilClass] nil value (=> no element)
    def on_text_node(content)
      return if content.match?(/\A\s*\Z/)

      text = content.gsub(/\A\s*\n\s*|\s*\n\s*\Z/, '').delete("\n").squeeze(' ')
      buffer << context.merge_styles.merge(text: ::Oga::HTML::Entities.decode(context.before_content) + text)
      context.last_text_node = true
      nil
    end

    # Render the buffer content to the PDF document
    def render
      return if buffer.empty?

      options = context.merge_options.slice(:align, :leading, :margin_left, :padding_left)
      output_content(buffer.dup, options)
      buffer.clear
      context.last_margin = 0
    end

    alias_method :flush, :render

    private

    attr_reader :buffer, :context, :doc_styles, :pdf

    def tag_classes
      @tag_classes ||= TAG_CLASSES.each_with_object({}) do |klass, res|
        res.merge!(klass.elements)
      end
    end

    def setup_element(element)
      add_space_if_needed unless render_if_needed(element)
      apply_pre_styles(element)
      element.apply_doc_styles(doc_styles)
      context.push(element)
    end

    def add_space_if_needed
      buffer << SPACE if buffer.any? && !context.last_text_node && ![NEW_LINE, SPACE].include?(buffer.last)
    end

    def render_if_needed(element)
      render_needed = element&.block? && buffer.any? && buffer.last != NEW_LINE
      return false unless render_needed

      render
      true
    end

    def apply_post_styles(styles)
      context.last_margin = styles[:margin_bottom].to_f
      return if !styles || styles.empty?

      pdf.move_down(context.last_margin.round(4)) if context.last_margin > 0
      pdf.move_down(styles[:padding_bottom].round(4)) if styles[:padding_bottom].to_f > 0
    end

    def apply_pre_styles(element)
      pdf.move_down(element.options[:padding_top].round(4)) if element.options.include?(:padding_top)
      return if !element.pre_styles || element.pre_styles.empty?

      margin = (element.pre_styles[:margin_top] - context.last_margin).round(4)
      pdf.move_down(margin) if margin > 0
    end

    def output_content(buffer, options)
      buffer.each { |item| item[:callback] = item[:callback].new(pdf, item) if item[:callback] }
      if (left = options.delete(:margin_left).to_f + options.delete(:padding_left).to_f) > 0
        pdf.indent(left) { pdf.formatted_text(buffer, options) }
      else
        pdf.formatted_text(buffer, options)
      end
    end
  end
end
