# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Ul < Base
      ELEMENTS = [:ul].freeze

      MARGIN_LEFT = 25

      def block?
        true
      end

      def extra_attrs
        @extra_attrs ||= {
          'margin-left' => MARGIN_LEFT.to_s,
        }
      end
    end
  end
end
