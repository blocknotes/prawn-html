# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Div < Tag
      ELEMENTS = [:div].freeze

      def block?
        true
      end
    end
  end
end
