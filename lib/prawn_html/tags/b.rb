# frozen_string_literal: true

module PrawnHtml
  module Tags
    class B < Tag
      ELEMENTS = [:b, :strong].freeze

      def extra_attrs
        {
          'font-weight' => 'bold'
        }
      end
    end
  end
end
