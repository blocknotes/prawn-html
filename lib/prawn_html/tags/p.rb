# frozen_string_literal: true

module PrawnHtml
  module Tags
    class P < Tag
      ELEMENTS = [:p].freeze

      MARGIN_BOTTOM = 12.5
      MARGIN_TOP = 12.5

      def block?
        true
      end

      def tag_styles
        <<~STYLES
          margin-bottom: #{MARGIN_BOTTOM}px;
          margin-top: #{MARGIN_TOP}px;
        STYLES
      end
    end
  end
end
