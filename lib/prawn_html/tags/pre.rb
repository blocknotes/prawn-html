# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Pre < Tag
      ELEMENTS = [:pre].freeze

      MARGIN_BOTTOM = 14
      MARGIN_TOP = 14

      def block?
        true
      end

      def tag_styles
        <<~STYLES
          font-family: Courier;
          margin-bottom: #{MARGIN_BOTTOM}px;
          margin-top: #{MARGIN_TOP}px;
          white-space: pre;
        STYLES
      end
    end
  end
end
