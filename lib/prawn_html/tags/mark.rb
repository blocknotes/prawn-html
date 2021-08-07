# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Mark < Base
      ELEMENTS = [:mark].freeze

      def styles
        super.merge(
          callback: Callbacks::Highlight
        )
      end
    end
  end
end
