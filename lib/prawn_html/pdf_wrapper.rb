# frozen_string_literal: true

require 'forwardable'

module PrawnHtml
  class PdfWrapper
    extend Forwardable

    def_delegators :@pdf, :bounding_box, :bounds, :cursor, :dash, :fill_color, :fill_color=, :fill_rectangle, :formatted_text, :image, :line, :move_cursor_to, :move_down, :stroke, :stroke_color, :stroke_color=, :stroke_horizontal_rule, :undash

    # Wrapper for Prawn PDF Document
    #
    # @param pdf_document [Prawn::Document] PDF document to wrap
    def initialize(pdf_document)
      @pdf = pdf_document
    end
  end
end
