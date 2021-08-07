# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Li < Base
      ELEMENTS = [:li].freeze

      def block?
        true
      end

      def options
        super.merge(
          before_content: '&bullet;  '
        )
      end
    end
  end
end
