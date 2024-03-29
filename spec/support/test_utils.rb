# frozen_string_literal: true

module TestUtils
  extend self

  def adjust_leading(size = PrawnHtml::Context::DEFAULT_STYLES[:size], font = nil)
    (size * PrawnHtml::ADJUST_LEADING[font]).round(4)
  end

  def default_font
    prawn_document.font('Helvetica', size: default_font_size)
  end

  def default_font_family
    default_font.family.to_sym
  end

  def default_font_size
    PrawnHtml::Context::DEFAULT_STYLES[:size]
  end

  def font_ascender(font_family: 'Helvetica', font_size: default_font_size)
    prawn_document.font(font_family, size: font_size).ascender
  end

  def font_string_width(pdf_doc, string, font_family: 'Helvetica', font_size: default_font_size, inline_format: false)
    width = 0
    pdf_doc.font(font_family, size: font_size) { width = pdf_doc.width_of(string, inline_format: inline_format) }
    width
  end

  def prawn_document
    ::Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
  end
end
