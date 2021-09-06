# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Ul < Tag
      ELEMENTS = [:ul].freeze

      MARGIN_TOP = 15
      MARGIN_LEFT = 40
      MARGIN_BOTTOM = 15

      def initialize(tag, attributes: {}, options: {})
        super
        @first_level = false
      end

      def block?
        true
      end

      def on_context_add(context)
        return if context.map(&:tag).count { |el| el == :ul } > 1

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
