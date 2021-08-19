# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
      ELEMENTS = [:li].freeze

      def block?
        true
      end

      def on_context_add(_context)
        @counter = (parent.counter += 1) if parent.is_a? Ol
      end

      def tag_styles
        {
          before_content: @counter ? "#{@counter}.  " : '&bullet;  '
        }
      end
    end
  end
end
