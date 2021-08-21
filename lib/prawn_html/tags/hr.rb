# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Hr < Tag
      ELEMENTS = [:hr].freeze

      MARGIN_BOTTOM = 12
      MARGIN_TOP = 6

      def block?
        true
      end

      def custom_render(pdf, _context)
        dash = attrs.data.include?('dash') ? parse_dash_value(attrs.data['dash']) : nil
        pdf.horizontal_rule(color: attrs.styles[:color], dash: dash)
      end

      def tag_styles
        @tag_styles ||= {
          'margin-bottom' => MARGIN_BOTTOM.to_s,
          'margin-top' => MARGIN_TOP.to_s,
        }
      end

      private

      def parse_dash_value(dash_string)
        if dash_string.match? /\A\d+\Z/
          dash_string.to_i
        else
          dash_array = dash_string.split(',')
          dash_array.map(&:to_i) if dash_array.any?
        end
      end
    end
  end
end
