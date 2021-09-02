# frozen_string_literal: true

module PrawnHtml
  module Callbacks
    class Highlight
      DEF_HIGHLIGHT = 'ffff00'

      def initialize(pdf, color = nil)
        @pdf = pdf
        @color = color || DEF_HIGHLIGHT
      end

      def render_behind(fragment)
        top, left = fragment.top_left
        @pdf.draw_rectangle(x: left, y: top, width: fragment.width, height: fragment.height, color: @color)
      end
    end
  end
end
