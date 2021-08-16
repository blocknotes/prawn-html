# frozen_string_literal: true

module PrawnHtml
  class Tag
    TAG_CLASSES = %w[A B Body Br Del Div H Hr I Img Li Mark P Small Span U Ul].freeze

    attr_reader :attrs, :styles, :tag

    # Init the Tag
    #
    # @param tag [Symbol] tag name
    # @param attributes [Hash] hash of element attributes
    # @param document_styles [Hash] hash of document styles
    def initialize(tag, attributes = {}, document_styles = {})
      @attrs = Attributes.new(attributes)
      @styles = attrs.parsed_styles
      @tag = tag
      merge_document_styles!(document_styles)
      @styles.merge!(attrs.process_styles(tag_styles)) if respond_to?(:tag_styles)
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

    def merge_document_styles!(document_styles)
      selectors = [
        tag.to_s,
        attrs['class'] ? ".#{attrs['class']}" : nil,
        attrs['id'] ? "##{attrs['id']}" : nil
      ].compact!
      merged_styles = document_styles.each_with_object({}) do |(sel, attributes), res|
        res.merge!(attributes) if selectors.include?(sel)
      end
      @styles = merged_styles.merge(styles)
    end
  end
end
