# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Del < Tag
      ELEMENTS = [:del, :s].freeze

      def tag_styles
        {
          'callback' => Callbacks::StrikeThrough
        }
      end
    end
  end
end
