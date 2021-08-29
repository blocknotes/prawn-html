# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Ul < Tag
      ELEMENTS = [:ul].freeze

      MARGIN_LEFT = 25

      def block?
        true
      end

      def tag_styles
        "margin-left: #{MARGIN_LEFT}px"
      end
    end
  end
end
