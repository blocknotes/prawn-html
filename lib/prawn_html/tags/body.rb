# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Body < Tag
      ELEMENTS = [:body].freeze

      def block?
        true
      end
    end
  end
end
