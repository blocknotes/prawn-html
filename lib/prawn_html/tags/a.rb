# frozen_string_literal: true

module PrawnHtml
  module Tags
    class A < Tag
      ELEMENTS = [:a].freeze

      def tag_styles
        return unless attrs.href

        <<~STYLES
          color: #00E;
          href: #{attrs.href};
          text-decoration: underline;
        STYLES
      end
    end
  end
end
