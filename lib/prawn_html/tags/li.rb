# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
      ELEMENTS = [:li].freeze

      def block?
        true
      end

      def before_content
        @counter ? "#{@counter}. " : "#{@symbol} "
      end

      def on_context_add(_context)
        @counter = (parent.counter += 1) if parent.is_a? Ol
        @symbol = parent.styles[:list_style_type] || '&bullet;' if parent.is_a? Ul
      end
    end
  end
end
