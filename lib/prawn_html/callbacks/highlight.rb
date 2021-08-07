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
        original_color = @pdf.fill_color
        @pdf.fill_color = @color
        @pdf.fill_rectangle(fragment.top_left, fragment.width, fragment.height)
        @pdf.fill_color = original_color
      end
    end
  end
end
