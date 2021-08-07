# frozen_string_literal: true

module PrawnHtml
  module Callbacks
    class StrikeThrough
      def initialize(pdf, _item)
        @pdf = pdf
      end

      def render_in_front(fragment)
        y = (fragment.top_left[1] + fragment.bottom_left[1]) / 2
        @pdf.stroke do
          @pdf.line [fragment.top_left[0], y], [fragment.top_right[0], y]
        end
      end
    end
  end
end
