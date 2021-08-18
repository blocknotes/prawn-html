# frozen_string_literal: true

module PrawnHtml
  module Utils
    # Converts a color string
    #
    # @param value [String] HTML string color
    #
    # @return [String] adjusted string color
    def convert_color(value)
      return '' if !value&.include? '#'

      val = value.downcase.gsub!(/[^a-f0-9]/, '')
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

    # Copy a value without conversion
    #
    # @param value
    #
    # @return value
    def copy(value)
      value
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

    module_function :convert_color, :convert_float, :convert_size, :convert_symbol, :copy, :unquote
  end
end
