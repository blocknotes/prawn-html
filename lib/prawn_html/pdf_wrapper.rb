# frozen_string_literal: true

require 'forwardable'

module PrawnHtml
  class PdfWrapper
    extend Forwardable

    def_delegators :@pdf, :bounds, :dash, :image, :line, :stroke, :stroke_color, :stroke_color=, :stroke_horizontal_rule, :undash

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
    def draw_rectangle(x:, y:, width:, height:, color:) # rubocop:disable Naming/MethodParameterName
      current_fill_color = pdf.fill_color
      pdf.fill_color = color
      pdf.fill_rectangle([y, x], width, height)
      pdf.fill_color = current_fill_color
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

    private

    attr_reader :pdf
  end
end
