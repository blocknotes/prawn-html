# frozen_string_literal: true

module PrawnHtml
  class Instance
    attr_reader :html_parser, :pdf_wrapper, :renderer

    def initialize(pdf)
      @pdf_wrapper = PrawnHtml::PdfWrapper.new(pdf)
      @renderer = PrawnHtml::DocumentRenderer.new(@pdf_wrapper)
      @html_parser = PrawnHtml::HtmlParser.new(@renderer)
    end

    def append(css: nil, html: nil)
      html_parser.parse_styles(css) if css
      html_parser.process(html) if html
    end
  end
end
