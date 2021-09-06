# frozen_string_literal: true

module PrawnHtml
  module Tags
    class H < Tag
      ELEMENTS = [:h1, :h2, :h3, :h4, :h5, :h6].freeze

      MARGINS_TOP = {
        h1: 25,
        h2: 20.5,
        h3: 18,
        h4: 21.2,
        h5: 21.2,
        h6: 22.8
      }.freeze

      MARGINS_BOTTOM = {
        h1: 15.8,
        h2: 15.8,
        h3: 15.8,
        h4: 20,
        h5: 21.4,
        h6: 24.8
      }.freeze

      SIZES = {
        h1: 31.5,
        h2: 24,
        h3: 18.7,
        h4: 15.7,
        h5: 13,
        h6: 10.8
      }.freeze

      def block?
        true
      end

      def tag_styles
        <<~STYLES
          font-size: #{SIZES[tag]}px;
          font-weight: bold;
          margin-bottom: #{MARGINS_BOTTOM[tag]}px;
          margin-top: #{MARGINS_TOP[tag]}px;
        STYLES
      end
    end
  end
end
