# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class B < Base
      ELEMENTS = [:b, :strong].freeze

      def extra_attrs
        {
          'font-weight' => 'bold'
        }
      end
    end
  end
end
