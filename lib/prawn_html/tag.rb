# frozen_string_literal: true

module PrawnHtml
  class Tag
    CALLBACKS = {
      'Highlight' => Callbacks::Highlight,
      'StrikeThrough' => Callbacks::StrikeThrough
    }.freeze
    TAG_CLASSES = %w[A B Blockquote Body Br Code Del Div H Hr I Img Li Mark Ol P Pre Small Span Sub Sup U Ul].freeze

    attr_accessor :parent
    attr_reader :attrs, :tag

    # Init the Tag
    #
    # @param tag [Symbol] tag name
    # @param attributes [Hash] hash of element attributes
    # @param element_styles [String] document styles tp apply to the element
    def initialize(tag, attributes: {}, element_styles: '')
      @tag = tag
      @attrs = Attributes.new(attributes)
      process_styles(element_styles, attributes['style'])
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

    # Styles to apply on tag closing
    #
    # @return [Hash] hash of styles to apply
    def tag_close_styles
      styles.slice(*Attributes::STYLES_APPLY[:tag_close])
    end

    # Styles hash
    #
    # @return [Hash] hash of styles
    def styles
      attrs.styles
    end

    # Styles to apply on tag opening
    #
    # @return [Hash] hash of styles to apply
    def tag_open_styles
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

    def process_styles(element_styles, inline_styles)
      attrs.merge_text_styles!(tag_styles) if respond_to?(:tag_styles)
      attrs.merge_text_styles!(element_styles)
      attrs.merge_text_styles!(inline_styles)
    end
  end
end
