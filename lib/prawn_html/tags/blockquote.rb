# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Blockquote < Tag
      ELEMENTS = [:blockquote].freeze

      MARGIN_BOTTOM = 12.7
      MARGIN_LEFT = 40.4
      MARGIN_TOP = 12.7

      def block?
        true
      end

      def tag_styles
        <<~STYLES
          margin-bottom: #{MARGIN_BOTTOM}px;
          margin-left: #{MARGIN_LEFT}px;
          margin-top: #{MARGIN_TOP}px;
        STYLES
      end
    end
  end
end
