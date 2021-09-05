# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Ol < Tag
      ELEMENTS = [:ol].freeze

      MARGIN_TOP = 15
      MARGIN_LEFT = 40
      MARGIN_BOTTOM = 15

      attr_accessor :counter

      def initialize(tag, attributes: {}, options: {})
        super
        @counter = 0
        @first_level = false
      end

      def block?
        true
      end

      def on_context_add(context)
        return if context.map(&:tag).count { |el| el == :ol } > 1

        @first_level = true
      end

      def tag_styles
        if @first_level
          <<~STYLES
            margin-top: #{MARGIN_TOP}px;
            margin-left: #{MARGIN_LEFT}px;
            margin-bottom: #{MARGIN_BOTTOM}px;
          STYLES
        else
          "margin-left: #{MARGIN_LEFT}px"
        end
      end
    end
  end
end
