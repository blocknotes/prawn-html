# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Hr < Base
      ELEMENTS = [:hr].freeze

      MARGIN_BOTTOM = 12
      MARGIN_TOP = 6

      def block?
        true
      end

      def custom_render(pdf, _context)
        pdf.stroke_horizontal_rule
      end

      def extra_attrs
        @extra_attrs ||= {
          'margin-bottom' => MARGIN_BOTTOM.to_s,
          'margin-top' => MARGIN_TOP.to_s,
        }
      end
    end
  end
end
