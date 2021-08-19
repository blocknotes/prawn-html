# frozen_string_literal: true

require 'ostruct'

module PrawnHtml
  class Attributes < OpenStruct
    attr_reader :styles

    STYLES_APPLY = {
      block: %i[align leading margin_left padding_left],
      tag_close: %i[margin_bottom padding_bottom],
      tag_open: %i[margin_top padding_top],
      text_node: %i[background callback character_spacing color font link list_style_type size styles]
    }.freeze

    STYLES_LIST = {
      # text node styles
      'background' => { key: :background, set: :convert_color },
      'callback' => { key: :callback, set: :copy_value },
      'color' => { key: :color, set: :convert_color },
      'font-family' => { key: :font, set: :unquote },
      'font-size' => { key: :size, set: :convert_size },
      'font-style' => { key: :styles, set: :append_symbol },
      'font-weight' => { key: :styles, set: :append_symbol },
      'href' => { key: :link, set: :copy_value },
      'letter-spacing' => { key: :character_spacing, set: :convert_float },
      'list-style-type' => { key: :list_style_type, set: :unquote },
      'text-decoration' => { key: :styles, set: :append_symbol },
      # tag opening styles
      'margin-top' => { key: :margin_top, set: :convert_size },
      'padding-top' => { key: :padding_top, set: :convert_size },
      # tag closing styles
      'margin-bottom' => { key: :margin_bottom, set: :convert_size },
      'padding-bottom' => { key: :padding_bottom, set: :convert_size },
      # block styles
      'line-height' => { key: :leading, set: :convert_size },
      'margin-left' => { key: :margin_left, set: :convert_size },
      'padding-left' => { key: :padding_left, set: :convert_size },
      'text-align' => { key: :align, set: :convert_symbol }
    }.freeze

    STYLES_MERGE = %i[margin_left padding_left].freeze

    # Init the Attributes
    def initialize(attributes = {})
      super
      @styles = {} # result styles
      return unless style

      styles_hash = Attributes.parse_styles(style)
      process_styles(styles_hash)
    end

    # Processes the data attributes
    #
    # @return [Hash] hash of data attributes with 'data-' prefix removed and stripped values
    def data
      to_h.each_with_object({}) do |(key, value), res|
        data_key = key.match /\Adata-(.+)/
        res[data_key[1]] = value.strip if data_key
      end
    end

    # Merge already parsed styles
    #
    # @param parsed_styles [Hash] hash of parsed styles
    def merge_styles!(parsed_styles)
      @styles.merge!(parsed_styles)
    end

    # Processes the styles attributes
    #
    # @param styles_hash [Hash] hash of styles attributes
    def process_styles(styles_hash)
      styles_hash.each do |key, value|
        apply_rule!(@styles, STYLES_LIST[key], value)
      end
      @styles
    end

    class << self
      # Merges attributes
      #
      # @param attributes [Hash] target attributes hash
      # @param key [Symbol] key
      # @param value
      #
      # @return [Hash] the updated hash of attributes
      def merge_attr!(attributes, key, value)
        return unless key
        return (attributes[key] = value) unless Attributes::STYLES_MERGE.include?(key)

        attributes[key] ||= 0
        attributes[key] += value
      end

      # Parses a string of styles
      #
      # @param styles [String] styles to parse
      #
      # @return [Hash] hash of styles
      def parse_styles(styles)
        (styles || '').scan(/\s*([^:;]+)\s*:\s*([^;]+)\s*/).to_h
      end
    end

    private

    def apply_rule!(result, rule, value)
      return unless rule

      if rule[:set] == :append_symbol
        (result[rule[:key]] ||= []) << Utils.convert_symbol(value)
      else
        result[rule[:key]] = Utils.send(rule[:set], value)
      end
    end
  end
end
