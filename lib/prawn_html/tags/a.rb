# frozen_string_literal: true

module PrawnHtml
  module Tags
    class A < Tag
      ELEMENTS = [:a].freeze

      def tag_styles
        "href: #{attrs.href}" if attrs.href
      end
    end
  end
end
