# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Sup < Tag
      ELEMENTS = [:sup].freeze

      def tag_styles
        'vertical-align: super'
      end
    end
  end
end
