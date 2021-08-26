# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Mark < Tag
      ELEMENTS = [:mark].freeze

      def tag_styles
        'callback: Highlight'
      end
    end
  end
end
