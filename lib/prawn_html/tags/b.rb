# frozen_string_literal: true

module PrawnHtml
  module Tags
    class B < Tag
      ELEMENTS = [:b, :strong].freeze

      def tag_styles
        {
          'font-weight' => 'bold'
        }
      end
    end
  end
end
