# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class A < Base
      ELEMENTS = [:a].freeze

      def styles
        super.merge(
          link: attrs.hash.href
        )
      end
    end
  end
end
