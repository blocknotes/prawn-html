# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Td < Tag
      ELEMENTS = [:td].freeze

      def block?
        true
      end

      def tag_opening(context: nil)
        super.tap do
          context.current_table&.new_cell
        end
      end
    end
  end
end
