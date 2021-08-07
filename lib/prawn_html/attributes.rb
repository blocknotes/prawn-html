# frozen_string_literal: true

require 'ostruct'

module PrawnHtml
  class Attributes
    attr_reader :hash, :styles

    # Init the Attributes
    #
    # @param attributes [Hash] hash of attributes to parse
    def initialize(attributes)
      @hash = ::OpenStruct.new(attributes)
      @styles = {} # result styles
    end
  end
end
