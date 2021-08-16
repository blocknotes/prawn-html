# frozen_string_literal: true

module PrawnHtml
  class Tag
    TAG_CLASSES = %w[A B Body Br Del Div H Hr I Img Li Mark P Small Span U Ul].freeze

    attr_reader :attrs, :styles, :tag

    # Init the Tag
    #
    # @param tag [Symbol] tag name
    # @param attributes [Hash] hash of element attributes
    def initialize(tag, attributes = {})
      @attrs = Attributes.new(attributes)
      @styles = attrs.styles
      @tag = tag
      attrs.process_styles(extra_attrs) unless extra_attrs.empty?
    end

    # Apply document styles to the tag
    #
    # @param document_styles [Hash] hash of document CSS rules
    #
    # @return [Hash] the merged styles
    def apply_doc_styles(document_styles)
      selectors = [
        tag.to_s,
        attrs.hash['class'] ? ".#{attrs.hash['class']}" : nil,
        attrs.hash['id'] ? "##{attrs.hash['id']}" : nil
      ].compact!
      merged_styles = document_styles.each_with_object({}) do |(sel, attributes), res|
        res.merge!(attributes) if selectors.include?(sel)
      end
      @styles = merged_styles.merge(styles)
    end

    # Is a block tag?
    #
    # @return [Boolean] true if the type of the tag is block, false otherwise
    def block?
      false
    end

    # Extra attributes
    #
    # @return [Hash] hash of extra attributes
    def extra_attrs
      {}
    end

    # Options
    #
    # @return [Hash] hash of options
    def options
      if attrs.data.include?('mode')
        { mode: attrs.data['mode'].to_sym }.merge(attrs.options)
      else
        attrs.options
      end
    end

    # Post styles
    #
    # @return [Hash] hash of post styles
    def post_styles
      attrs.post_styles
    end

    # Pre styles
    #
    # @return [Hash] hash of pre styles
    def pre_styles
      attrs.pre_styles
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
  end
end
