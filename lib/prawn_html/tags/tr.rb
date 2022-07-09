# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Tr < Tag
      ELEMENTS = [:tr].freeze

      def block?
        true
      end

      def tag_opening(context: nil)
        super.tap do
          context.current_table&.new_row
        end
      end
    end
  end
end
