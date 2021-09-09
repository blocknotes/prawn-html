# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
      ELEMENTS = [:li].freeze

      INDENT_OL = -12
      INDENT_UL = -6

      def block?
        true
      end

      def before_content
        @counter ? "#{@counter}. " : "#{@symbol} "
      end

      def block_styles
        super.tap do |bs|
          bs[:indent_paragraphs] = @indent
        end
      end

      def on_context_add(_context)
        case parent.class.to_s
        when 'PrawnHtml::Tags::Ol'
          @indent = INDENT_OL
          @counter = (parent.counter += 1)
        when 'PrawnHtml::Tags::Ul'
          @indent = INDENT_UL
          @symbol = parent.styles[:list_style_type] || '&bullet;'
        end
      end
    end
  end
end
