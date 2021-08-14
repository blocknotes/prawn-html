# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
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
