# frozen_string_literal: true

require 'forwardable'

module PrawnHtml
  class PdfWrapper
    extend Forwardable

    def_delegators :@pdf, :bounding_box, :bounds, :cursor, :dash, :fill_color, :fill_color=, :fill_rectangle, :formatted_text, :image, :line, :move_cursor_to, :stroke, :stroke_color, :stroke_color=, :stroke_horizontal_rule, :undash

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

    private

    attr_reader :pdf
  end
end
