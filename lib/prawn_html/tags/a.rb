# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class A < Base
      ELEMENTS = [:a].freeze

      def styles
        attrs.hash.href ? super.merge(link: attrs.hash.href) : super
      end
    end
  end
end
