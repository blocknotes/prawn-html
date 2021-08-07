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

    class << self
      # Converts a color string
      #
      # @param value [String] HTML string color
      #
      # @return [String] adjusted string color
      def convert_color(value)
        val = value&.downcase || +''
        val.gsub!(/[^a-f0-9]/, '')
        return val unless val.size == 3

        a, b, c = val.chars
        a * 2 + b * 2 + c * 2
      end

      # Converts a decimal number string
      #
      # @param value [String] string decimal
      #
      # @return [Float] converted and rounded float number
      def convert_float(value)
        val = value&.gsub(/[^0-9.]/, '') || ''
        val.to_f.round(4)
      end

      # Converts a size string
      #
      # @param value [String] size string
      # @param container_size [Numeric] container size
      #
      # @return [Float] converted and rounded size
      def convert_size(value, container_size = nil)
        val = value&.gsub(/[^0-9.]/, '') || ''
        val =
          if container_size && value.include?('%')
            val.to_f * container_size * 0.01
          else
            val.to_f * PX
          end
        # pdf.bounds.height
        val.round(4)
      end

      # Converts a string to symbol
      #
      # @param value [String] string
      #
      # @return [Symbol] symbol
      def convert_symbol(value)
        value.to_sym if value && !value.match?(/\A\s*\Z/)
      end

      # Merges attributes
      #
      # @param hash [Hash] target attributes hash
      # @param key [Symbol] key
      # @param value
      def merge_attr!(hash, key, value)
        # TODO
      end

      # Unquotes a string
      #
      # @param value [String] string
      #
      # @return [String] string without quotes at the beginning/ending
      def unquote(value)
        (value&.strip || +'').tap do |val|
          val.gsub!(/\A['"]|["']\Z/, '')
        end
      end
    end
  end
end
