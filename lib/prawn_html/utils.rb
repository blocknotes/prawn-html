# frozen_string_literal: true

module PrawnHtml
  module Utils
    NORMALIZE_STYLES = {
      'bold' => :bold,
      'italic' => :italic,
      'sub' => :subscript,
      'super' => :superscript,
      'underline' => :underline
    }.freeze

    # Converts a color string
    #
    # Supported formats:
    # - 3 hex digits, ex. `color: #FB1`;
    # - 6 hex digits, ex. `color: #abcdef`;
    # - RGB, ex. `color: RGB(64, 0, 128)`;
    # - color name, ex. `color: red`.
    #
    # @param value [String] HTML string color
    #
    # @return [String] adjusted string color or nil if value is invalid
    def convert_color(value, options: nil)
      val = value.to_s.strip.downcase
      return Regexp.last_match[1] if val.match /\A#([a-f0-9]{6})\Z/ # rubocop:disable Performance/RedundantMatch

      if val.match /\A#([a-f0-9]{3})\Z/ # rubocop:disable Performance/RedundantMatch
        r, g, b = Regexp.last_match[1].chars
        return r * 2 + g * 2 + b * 2
      end
      if val.match /\Argb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)\Z/ # rubocop:disable Performance/RedundantMatch
        r, g, b = Regexp.last_match[1..3].map { |v| v.to_i.to_s(16) }
        return "#{r.rjust(2, '0')}#{g.rjust(2, '0')}#{b.rjust(2, '0')}"
      end

      COLORS[val]
    end

    # Converts a decimal number string
    #
    # @param value [String] string decimal
    #
    # @return [Float] converted and rounded float number
    def convert_float(value, options: nil)
      val = value&.gsub(/[^0-9.]/, '') || ''
      val.to_f.round(4)
    end

    # Converts a size string
    #
    # @param value [String] size string
    # @param options [Numeric] container size
    #
    # @return [Float] converted and rounded size
    def convert_size(value, options: nil)
      val = value&.gsub(/[^0-9.]/, '') || ''
      val =
        if options && value&.include?('%')
          val.to_f * options * 0.01
        else
          val.to_f * PrawnHtml::PX
        end
      val.round(4)
    end

    # Converts a string to symbol
    #
    # @param value [String] string
    #
    # @return [Symbol] symbol
    def convert_symbol(value, options: nil)
      value.to_sym if value && !value.match?(/\A\s*\Z/)
    end

    # Copy a value without conversion
    #
    # @param value
    #
    # @return value
    def copy_value(value, options: nil)
      value
    end

    # Normalize a style value
    #
    # @param value [String] string value
    #
    # @return [Symbol] style value or nil
    def normalize_style(value)
      val = value&.strip&.downcase
      NORMALIZE_STYLES[val]
    end

    # Unquotes a string
    #
    # @param value [String] string
    #
    # @return [String] string without quotes at the beginning/ending
    def unquote(value, options: nil)
      (value&.strip || +'').tap do |val|
        val.gsub!(/\A['"]|["']\Z/, '')
      end
    end

    module_function :convert_color, :convert_float, :convert_size, :convert_symbol, :copy_value, :normalize_style,
                    :unquote
  end
end
