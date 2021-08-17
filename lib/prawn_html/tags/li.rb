# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
      ELEMENTS = [:li].freeze

      def block?
        true
      end

      def tag_styles
        {
          before_content: '&bullet;  '
        }
      end
    end
  end
end
