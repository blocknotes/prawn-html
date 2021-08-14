# frozen_string_literal: true

module PrawnHtml
  module Tags
    class I < Tag
      ELEMENTS = [:i, :em].freeze

      def extra_attrs
        {
          'font-style' => 'italic'
        }
      end
    end
  end
end
