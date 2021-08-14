# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Small < Tag
      ELEMENTS = [:small].freeze

      def update_styles(styles)
        size = (styles[:size] || Context::DEF_FONT_SIZE) * 0.85
        styles[:size] = size
        styles
      end
    end
  end
end
