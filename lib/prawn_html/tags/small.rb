# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Small < Base
      ELEMENTS = [:small].freeze

      def update_styles(styles)
        size = (styles[:size] || Context::DEF_FONT_SIZE) * 0.85
        styles[:size] = size
      end
    end
  end
end
