# frozen_string_literal: true

require 'ostruct'

module PrawnHtml
  class Attributes < OpenStruct
    attr_reader :styles

    STYLES_APPLY = {
      block: %i[align bottom leading left margin_left padding_left position right top],
      tag_close: %i[margin_bottom padding_bottom break_after],
      tag_open: %i[margin_top padding_top break_before],
      text_node: %i[callback character_spacing color font link list_style_type size styles white_space]
    }.freeze

    STYLES_LIST = {
      # text node styles
      'background' => { key: :callback, set: :callback_background },
      'color' => { key: :color, set: :convert_color },
      'font-family' => { key: :font, set: :unquote },
      'font-size' => { key: :size, set: :convert_size },
      'font-style' => { key: :styles, set: :append_styles },
      'font-weight' => { key: :styles, set: :append_styles },
      'href' => { key: :link, set: :copy_value },
      'letter-spacing' => { key: :character_spacing, set: :convert_float },
      'list-style-type' => { key: :list_style_type, set: :unquote },
      'text-decoration' => { key: :styles, set: :append_styles },
      'vertical-align' => { key: :styles, set: :append_styles },
      'white-space' => { key: :white_space, set: :convert_symbol },
      # tag opening styles
      'break-before' => { key: :break_before, set: :convert_symbol },
      'margin-top' => { key: :margin_top, set: :convert_size },
      'padding-top' => { key: :padding_top, set: :convert_size },
      # tag closing styles
      'break-after' => { key: :break_after, set: :convert_symbol },
      'margin-bottom' => { key: :margin_bottom, set: :convert_size },
      'padding-bottom' => { key: :padding_bottom, set: :convert_size },
      # block styles
      'bottom' => { key: :bottom, set: :convert_size, options: :height },
      'left' => { key: :left, set: :convert_size, options: :width },
      'line-height' => { key: :leading, set: :convert_size },
      'margin-left' => { key: :margin_left, set: :convert_size },
      'padding-left' => { key: :padding_left, set: :convert_size },
      'position' => { key: :position, set: :convert_symbol },
      'right' => { key: :right, set: :convert_size, options: :width },
      'text-align' => { key: :align, set: :convert_symbol },
      'top' => { key: :top, set: :convert_size, options: :height },
      # special styles
      'text-decoration-line-through' => { key: :callback, set: :callback_strike_through }
    }.freeze

    STYLES_MERGE = %i[margin_left padding_left].freeze

    # Init the Attributes
    def initialize(attributes = {})
      super
      @styles = {} # result styles
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

    # Merge text styles
    #
    # @param text_styles [String] styles to parse and process
    # @param options [Hash] options (container width/height/etc.)
    def merge_text_styles!(text_styles, options: {})
      hash_styles = Attributes.parse_styles(text_styles)
      process_styles(hash_styles, options: options) unless hash_styles.empty?
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

    def process_styles(hash_styles, options:)
      hash_styles.each do |key, value|
        rule = evaluate_rule(key, value)
        next unless rule

        apply_rule!(merged_styles: @styles, rule: rule, value: value, options: options)
      end
      @styles
    end

    def evaluate_rule(rule_key, attr_value)
      key = nil
      key = 'text-decoration-line-through' if rule_key == 'text-decoration' && attr_value == 'line-through'
      key ||= rule_key
      STYLES_LIST[key]
    end

    def apply_rule!(merged_styles:, rule:, value:, options:)
      if rule[:set] == :append_styles
        val = Utils.normalize_style(value)
        (merged_styles[rule[:key]] ||= []) << val if val
      else
        opts = rule[:options] ? options[rule[:options]] : nil
        val = Utils.send(rule[:set], value, options: opts)
        merged_styles[rule[:key]] = val if val
      end
    end
  end
end
