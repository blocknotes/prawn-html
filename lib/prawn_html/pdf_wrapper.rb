# frozen_string_literal: true

require 'forwardable'

module PrawnHtml
  class PdfWrapper
    extend Forwardable

    def_delegators :@pdf, :bounds, :image

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

    # Output to the PDF document
    #
    # @param buffer [Array] array of text items
    # @param options [Hash] hash of options
    # @param bounding_box [Array] bounding box arguments, if bounded
    def puts(buffer, options, bounding_box: nil)
      return pdf.formatted_text(buffer, options) unless bounding_box

      current_y = pdf.cursor
      pdf.bounding_box(*bounding_box) do
        pdf.formatted_text(buffer, options)
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
  end
end
