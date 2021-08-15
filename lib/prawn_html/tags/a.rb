# frozen_string_literal: true

module PrawnHtml
  module Tags
    class A < Tag
      ELEMENTS = [:a].freeze

      def tag_styles
        attrs.hash.href ? { 'href' => attrs.hash.href } : {}
      end
    end
  end
end
