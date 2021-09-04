# frozen_string_literal: true

require 'forwardable'

module PrawnHtml
  class PdfWrapper
    extend Forwardable

    def_delegators :@pdf, :start_new_page

    # Wrapper for Prawn PDF Document
    #
    # @param pdf_document [Prawn::Document] PDF document to wrap
    def initialize(pdf_document)
      @pdf = pdf_document
    end

    # Advance the cursor
    #
    # @param move_down [Float] Quantity to advance (move down)
    def advance_cursor(move_down)
      return if !move_down || move_down == 0

      pdf.move_down(move_down)
    end

    # Calculate the height of a buffer of items
    #
    # @param buffer [Array] Buffer of items
    # @param options [Hash] Output options
    #
    # @return [Float] calculated height
    def calc_buffer_height(buffer, options)
      pdf.height_of_formatted(buffer, options)
    end

    # Calculate the width of a buffer of items
    #
    # @param buffer [Array] Buffer of items
    #
    # @return [Float] calculated width
    def calc_buffer_width(buffer)
      width = 0
      buffer.each do |item|
        font_family = item[:font] || pdf.font.name
        pdf.font(font_family, size: item[:size] || pdf.font_size) do
          width += pdf.width_of(item[:text], inline_format: true)
        end
      end
      width
    end

    # Height of the page
    #
    # @return [Float] height
    def page_height
      pdf.bounds.height
    end

    # Width of the page
    #
    # @return [Float] width
    def page_width
      pdf.bounds.width
    end

    # Draw a rectangle
    #
    # @param x [Float] left position of the rectangle
    # @param y [Float] top position of the rectangle
    # @param width [Float] width of the rectangle
    # @param height [Float] height of the rectangle
    # @param color [String] fill color
    def draw_rectangle(x:, y:, width:, height:, color:)
      current_fill_color = pdf.fill_color
      pdf.fill_color = color
      pdf.fill_rectangle([y, x], width, height)
      pdf.fill_color = current_fill_color
    end

    # Horizontal line
    #
    # @param color [String] line color
    # @param dash [Integer|Array] integer or array of integer with dash options
    def horizontal_rule(color:, dash:)
      current_color = pdf.stroke_color
      pdf.dash(dash) if dash
      pdf.stroke_color = color if color
      pdf.stroke_horizontal_rule
      pdf.stroke_color = current_color if color
      pdf.undash if dash
    end

    # Image
    #
    # @param src [String] image source path
    # @param options [Hash] hash of options
    def image(src, options = {})
      return unless src

      pdf.image(src, options)
    end

    # Output to the PDF document
    #
    # @param buffer [Array] array of text items
    # @param options [Hash] hash of options
    # @param bounding_box [Array] bounding box arguments, if bounded
    def puts(buffer, options, bounding_box: nil, left_indent: 0)
      return output_buffer(buffer, options, left_indent: left_indent) unless bounding_box

      current_y = pdf.cursor
      pdf.bounding_box(*bounding_box) do
        output_buffer(buffer, options, left_indent: left_indent)
      end
      pdf.move_cursor_to(current_y)
    end

    # Underline
    #
    # @param x1 [Float] left position of the line
    # @param x2 [Float] right position of the line
    # @param y [Float] vertical position of the line
    def underline(x1:, x2:, y:)
      pdf.stroke do
        pdf.line [x1, y], [x2, y]
      end
    end

    private

    attr_reader :pdf

    def output_buffer(buffer, options, left_indent:)
      formatted_text = proc { pdf.formatted_text(buffer, options) }
      return formatted_text.call if left_indent == 0

      pdf.indent(left_indent, 0, &formatted_text)
    end
  end
end
