# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Sub < Tag
      ELEMENTS = [:sub].freeze

      def tag_styles
        'vertical-align: sub'
      end
    end
  end
end
