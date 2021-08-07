# frozen_string_literal: true

module PrawnHtml
  class Context < Array
    DEF_FONT_SIZE = 10.3

    attr_accessor :last_margin, :last_text_node

    # Init the Context
    def initialize(*_args)
      super
      @last_margin = 0
    end

    # Merges the context options
    #
    # @return [Hash] the hash of merged options
    def merge_options
      each_with_object({}) do |element, res|
        element.options.each do |key, value|
          Attributes.merge_attr!(res, key, value)
        end
      end
    end
  end
end
