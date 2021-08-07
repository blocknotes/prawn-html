# frozen_string_literal: true

require_relative 'base'

module PrawnHtml
  module Tags
    class Del < Base
      ELEMENTS = [:del, :s].freeze

      def styles
        super.merge(
          callback: Callbacks::StrikeThrough
        )
      end
    end
  end
end
