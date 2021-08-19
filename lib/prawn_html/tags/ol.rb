# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Ol < Tag
      ELEMENTS = [:ol].freeze

      MARGIN_LEFT = 25

      attr_accessor :counter

      def initialize(tag, attributes: {}, document_styles: '')
        super
        @counter = 0
      end

      def block?
        true
      end

      def tag_styles
        @tag_styles ||= {
          'margin-left' => MARGIN_LEFT.to_s,
        }
      end
    end
  end
end
