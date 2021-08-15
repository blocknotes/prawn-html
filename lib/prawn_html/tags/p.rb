# frozen_string_literal: true

module PrawnHtml
  module Tags
    class P < Tag
      ELEMENTS = [:p].freeze

      MARGIN_BOTTOM = 6
      MARGIN_TOP = 6

      def block?
        true
      end

      def tag_styles
        @tag_styles ||= {
          'margin-bottom' => MARGIN_BOTTOM.to_s,
          'margin-top' => MARGIN_TOP.to_s
        }
      end
    end
  end
end
