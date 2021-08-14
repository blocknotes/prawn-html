# frozen_string_literal: true

module PrawnHtml
  module Tags
    class A < Tag
      ELEMENTS = [:a].freeze

      def styles
        attrs.hash.href ? super.merge(link: attrs.hash.href) : super
      end
    end
  end
end
