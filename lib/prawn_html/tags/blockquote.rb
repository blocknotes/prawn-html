# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Blockquote < Tag
      ELEMENTS = [:blockquote].freeze

      MARGIN_BOTTOM = 10
      MARGIN_LEFT = 25
      MARGIN_TOP = 10

      def block?
        true
      end

      def tag_styles
        @tag_styles ||= {
          'margin-bottom' => MARGIN_BOTTOM.to_s,
          'margin-left' => MARGIN_LEFT.to_s,
          'margin-top' => MARGIN_TOP.to_s
        }
      end
    end
  end
end
