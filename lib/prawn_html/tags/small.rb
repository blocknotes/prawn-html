# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Small < Tag
      ELEMENTS = [:small].freeze

      def update_styles(context_styles)
        size = (context_styles[:size] || Context::DEF_FONT_SIZE) * 0.85
        context_styles[:size] = size
        super(context_styles)
      end
    end
  end
end
