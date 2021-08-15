# frozen_string_literal: true

module PrawnHtml
  module Tags
    class U < Tag
      ELEMENTS = [:ins, :u].freeze

      def tag_styles
        {
          'text-decoration' => 'underline'
        }
      end
    end
  end
end
