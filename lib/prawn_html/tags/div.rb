# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Div < Base
      ELEMENTS = [:div].freeze

      def block?
        true
      end
    end
  end
end
