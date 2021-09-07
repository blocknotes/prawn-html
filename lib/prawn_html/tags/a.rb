# frozen_string_literal: true

module PrawnHtml
  module Tags
    class A < Tag
      ELEMENTS = [:a].freeze

      def extra_styles
        attrs.href ? "href: #{attrs.href}" : nil
      end

      def tag_styles
        <<~STYLES
          color: #00E;
          text-decoration: underline;
        STYLES
      end
    end
  end
end
