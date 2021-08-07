# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Base
      attr_reader :attrs, :styles, :tag

      def initialize(tag, attributes = {})
        @attrs = Attributes.new(attributes)
        @styles = attrs.styles
        @tag = tag
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
end
