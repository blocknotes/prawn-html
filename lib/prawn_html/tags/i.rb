# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class I < Base
      ELEMENTS = [:i, :em].freeze

      def extra_attrs
        {
          'font-style' => 'italic'
        }
      end
    end
  end
end
