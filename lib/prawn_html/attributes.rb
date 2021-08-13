# frozen_string_literal: true

require 'ostruct'

module PrawnHtml
  class Attributes
    attr_reader :hash, :options, :post_styles, :pre_styles, :styles

    STYLES_LIST = {
      # styles
      'background' => { key: :background, set: :convert_color, dest: :styles },
      'color' => { key: :color, set: :convert_color, dest: :styles },
      'font-family' => { key: :font, set: :unquote, dest: :styles },
      'font-size' => { key: :size, set: :convert_size, dest: :styles },
      'font-style' => { key: :styles, set: :append_symbol, dest: :styles },
      'font-weight' => { key: :styles, set: :append_symbol, dest: :styles },
      'letter-spacing' => { key: :character_spacing, set: :convert_float, dest: :styles },
      # pre styles
      'margin-top' => { key: :margin_top, set: :convert_size, dest: :pre_styles },
      # post styles
      'margin-bottom' => { key: :margin_bottom, set: :convert_size, dest: :post_styles },
      'padding-bottom' => { key: :padding_bottom, set: :convert_size, dest: :post_styles },
      # options
      'line-height' => { key: :leading, set: :convert_size, dest: :options },
      'margin-left' => { key: :margin_left, set: :convert_size, dest: :options },
      'padding-left' => { key: :padding_left, set: :convert_size, dest: :options },
      'padding-top' => { key: :padding_top, set: :convert_size, dest: :options },
      'text-align' => { key: :align, set: :convert_symbol, dest: :options },
      'text-decoration' => { key: :styles, set: :append_symbol, dest: :styles }
    }.freeze

    STYLES_MERGE = %i[margin_left padding_left].freeze

    # Init the Attributes
    #
    # @param attributes [Hash] hash of attributes to parse
    def initialize(attributes)
      @hash = ::OpenStruct.new(attributes)
      @options = {}
      @post_styles = {}
      @pre_styles = {}
      @styles = {} # result styles
      parsed_styles = Attributes.parse_styles(hash.style)
      process_styles(parsed_styles)
    end

    # Processes the data attributes
    #
    # @return [Hash] hash of data attributes with 'data-' prefix removed and stripped values
    def data
      hash.to_h.each_with_object({}) do |(key, value), res|
        data_key = key.match /\Adata-(.+)/
        res[data_key[1]] = value.strip if data_key
      end
    end

    # Processes the styles attributes
    #
    # @param attributes [Hash] hash of styles attributes
    def process_styles(styles)
      styles.each do |key, value|
        rule = STYLES_LIST[key]
        next unless rule

        apply_rule(rule, value)
      end
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
      #
      # @return [Hash] the updated hash of attributes
      def merge_attr!(hash, key, value)
        return unless key
        return (hash[key] = value) unless Attributes::STYLES_MERGE.include?(key)

        hash[key] ||= 0
        hash[key] += value
      end

      # Parses a string of styles
      #
      # @param styles [String] styles to parse
      #
      # @return [Hash] hash of styles
      def parse_styles(styles)
        (styles || '').scan(/\s*([^:;]+)\s*:\s*([^;]+)\s*/).to_h
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

    private

    def apply_rule(rule, value)
      if rule[:set] == :append_symbol
        (send(rule[:dest])[rule[:key]] ||= []) << Attributes.convert_symbol(value)
      else
        send(rule[:dest])[rule[:key]] = Attributes.send(rule[:set], value)
      end
    end
  end
end
