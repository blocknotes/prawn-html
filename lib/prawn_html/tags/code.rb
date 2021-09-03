# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Code < Tag
      ELEMENTS = [:code].freeze

      def tag_styles
        'font-family: Courier'
      end
    end
  end
end
