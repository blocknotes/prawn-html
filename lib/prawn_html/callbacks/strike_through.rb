# frozen_string_literal: true

module PrawnHtml
  module Callbacks
    class StrikeThrough
      def initialize(pdf, _item)
        @pdf = pdf
      end

      def render_in_front(fragment)
        x1 = fragment.left
        x2 = fragment.right
        y = (fragment.top + fragment.bottom) / 2
        @pdf.underline(x1: x1, x2: x2, y: y)
      end
    end
  end
end
