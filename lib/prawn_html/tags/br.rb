# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Br < Tag
      ELEMENTS = [:br].freeze

      BR_SPACING = Utils.convert_size('12')

      def block?
        true
      end

      def custom_render(pdf, context)
        return if context.last_text_node

        pdf.advance_cursor(BR_SPACING)
      end
    end
  end
end
