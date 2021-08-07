# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Br < Base
      ELEMENTS = [:br].freeze

      BR_SPACING = 12

      def block?
        true
      end

      def custom_render(pdf, context)
        return if context.last_text_node

        @spacing ||= Attributes.convert_size(BR_SPACING.to_s)
        pdf.move_down(@spacing)
      end
    end
  end
end
