# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Li < Tag
      ELEMENTS = [:li].freeze

      INDENT_OL = -12
      INDENT_UL = -6

      def block?
        true
      end

      def before_content
        return if @before_content_once
        @before_content_once = @counter ? "#{counter_display(@counter, parent.attrs.type)}. " : "#{@symbol} "
      end

      def block_styles
        super.tap do |bs|
          bs[:indent_paragraphs] = @indent
        end
      end

      def on_context_add(_context)
        case parent.class.to_s
        when 'PrawnHtml::Tags::Ol'
          @indent = INDENT_OL
          @counter = (parent.counter += 1)
        when 'PrawnHtml::Tags::Ul'
          @indent = INDENT_UL
          @symbol = parent.styles[:list_style_type] || '&bullet;'
        end
      end

      def counter_display(counter, ol_type = '1')
        case ol_type
        when '1'
          counter.to_s
        when 'a'
          to_char(counter).downcase
        when 'A'
          to_char(counter)
        when 'i'
          to_roman(counter).downcase
        when 'I'
          to_roman(counter)
        else
          counter.to_s
        end        
      end
    
      def to_roman(num)
        roman_arr = {
          1000 => "M",
          900 => "CM",
          500 => "D",
          400 => "CD",
          100 => "C",
          90 => "XC",
          50 => "L",
          40 => "XL",
          10 => "X",
          9 => "IX",
          5 => "V",
          4 => "IV",
          1 => "I"
        }     
        roman_arr.reduce(+"") do |roman_res, (arab, roman)|
          whole_part, num = num.divmod(arab)
          roman_res << roman * whole_part
        end
      end
    
      def to_char(num)
        chars = ("A".."Z").to_a
        return "" if num < 1
        s = +""
        q = num
        loop do
          q, r = (q - 1).divmod(26)
          s.prepend(chars[r]) 
          break if q.zero?
        end
        s
      end
    end
  end
end
