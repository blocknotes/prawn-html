# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class P < Base
      ELEMENTS = [:p].freeze

      MARGIN_BOTTOM = 6
      MARGIN_TOP = 6

      def block?
        true
      end

      def extra_attrs
        @extra_attrs ||= {
          'margin-bottom' => MARGIN_BOTTOM.to_s,
          'margin-top' => MARGIN_TOP.to_s
        }
      end
    end
  end
end
