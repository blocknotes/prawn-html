# frozen_string_literal: true

module PrawnHtml
  class Tag
    extend Forwardable

    CALLBACKS = {
      'Background' => Callbacks::Background,
      'StrikeThrough' => Callbacks::StrikeThrough
    }.freeze

    TAG_CLASSES = %w[A B Blockquote Body Br Code Del Div H Hr I Img Li Mark Ol P Pre Small Span Sub Sup U Ul].freeze

    def_delegators :@attrs, :styles, :update_styles

    attr_accessor :parent
    attr_reader :attrs, :tag

    # Init the Tag
    #
    # @param tag [Symbol] tag name
    # @param attributes [Hash] hash of element attributes
    # @param options [Hash] options (container width/height/etc.)
    def initialize(tag, attributes: {}, options: {})
      @tag = tag
      @options = options
      @attrs = Attributes.new(attributes)
    end

    # Is a block tag?
    #
    # @return [Boolean] true if the type of the tag is block, false otherwise
    def block?
      false
    end

    # Styles to apply to the block
    #
    # @return [Hash] hash of styles to apply
    def block_styles
      block_styles = styles.slice(*Attributes::STYLES_APPLY[:block])
      block_styles[:mode] = attrs.data['mode'].to_sym if attrs.data.include?('mode')
      block_styles
    end

    # Process tag styles
    #
    # @param element_styles [String] extra styles to apply to the element
    def process_styles(element_styles: nil)
      attrs.merge_text_styles!(tag_styles, options: options) if respond_to?(:tag_styles)
      attrs.merge_text_styles!(element_styles, options: options) if element_styles
      attrs.merge_text_styles!(attrs.style, options: options)
      attrs.merge_text_styles!(extra_styles, options: options) if respond_to?(:extra_styles)
    end

    # Tag closing callback that applies tag's specific styles
    #
    # @return [Hash] hash of styles to apply
    def tag_closing(context: nil)
      styles.slice(*Attributes::STYLES_APPLY[:tag_close])
    end

    # Tag opening callback that applies tag's specific styles
    #
    # @return [Hash] hash of styles to apply
    def tag_opening(context: nil)
      styles.slice(*Attributes::STYLES_APPLY[:tag_open])
    end

    class << self
      # Evaluate the Tag class from a tag name
      #
      # @params tag_name [Symbol] the tag name
      #
      # @return [Tag] the class for the tag if available or nil
      def class_for(tag_name)
        @tag_classes ||= TAG_CLASSES.each_with_object({}) do |tag_class, res|
          klass = const_get("PrawnHtml::Tags::#{tag_class}")
          k = [klass] * klass::ELEMENTS.size
          res.merge!(klass::ELEMENTS.zip(k).to_h)
        end
        @tag_classes[tag_name]
      end
    end

    private

    attr_reader :options
  end
end
