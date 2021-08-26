# frozen_string_literal: true

module PrawnHtml
  module Tags
    class H < Tag
      ELEMENTS = [:h1, :h2, :h3, :h4, :h5, :h6].freeze

      MARGINS_TOP = {
        h1: 25.5,
        h2: 20.5,
        h3: 19,
        h4: 20,
        h5: 21.2,
        h6: 23.5
      }.freeze

      MARGINS_BOTTOM = {
        h1: 18.2,
        h2: 17.5,
        h3: 17.5,
        h4: 22,
        h5: 22,
        h6: 26.5
      }.freeze

      SIZES = {
        h1: 31,
        h2: 23.5,
        h3: 18.2,
        h4: 16,
        h5: 13,
        h6: 10.5
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
