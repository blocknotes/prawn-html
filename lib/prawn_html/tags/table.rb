# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Table < Tag
      ELEMENTS = [:table].freeze

      attr_reader :table_data

      def block?
        true
      end

      def new_cell
        @col_index += 1
        @table_data[@row_index] << ''
      end

      def new_row
        @row_index += 1
        @col_index = -1
        @table_data << []
      end

      def update_content(content)
        @table_data[@row_index][@col_index] = content
      end

      def tag_opening(context: nil)
        super.tap do
          context.current_table = self
          @row_index = -1
          @table_data = []
        end
      end

      def tag_closing(context: nil)
        super.tap do
          context.current_table = nil
        end
      end
    end
  end
end
