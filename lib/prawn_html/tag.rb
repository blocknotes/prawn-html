# frozen_string_literal: true

module PrawnHtml
  class Tag
      attr_reader :attrs, :styles, :tag

      def initialize(tag, attributes = {})
        @attrs = Attributes.new(attributes)
        @styles = attrs.styles
        @tag = tag
        attrs.process_styles(extra_attrs) unless extra_attrs.empty?
      end

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

      def block?
        false
      end

      def extra_attrs
        {}
      end

      def options
        attrs.options
      end

      def post_styles
        attrs.post_styles
      end

      def pre_styles
        attrs.pre_styles
      end

      class << self
        def elements
          self::ELEMENTS.each_with_object({}) { |el, list| list[el] = self }
        end
      end
  end
end
