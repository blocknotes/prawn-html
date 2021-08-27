# frozen_string_literal: true

module PrawnHtml
  module Callbacks
    class Highlight
      DEF_HIGHLIGHT = 'ffff00'

      def initialize(pdf, item)
        @pdf = pdf
        @color = item.delete(:background) || DEF_HIGHLIGHT
      end

      def render_behind(fragment)
        top, left = fragment.top_left
        @pdf.draw_rectangle(x: left, y: top, width: fragment.width, height: fragment.height, color: @color)
      end
    end
  end
end
