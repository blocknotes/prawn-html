# frozen_string_literal: true

RSpec.shared_context 'with pdf wrapper' do
  let(:pdf) do
    methods = { advance_cursor: true, puts: true, horizontal_rule: true }
    instance_double(PrawnHtml::PdfWrapper, methods)
  end

  def append_html_to_pdf(html)
    allow(pdf).to receive_messages(page_width: 540, page_height: 720)
    allow(PrawnHtml::PdfWrapper).to receive(:new).and_return(pdf)
    pdf_document = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    PrawnHtml.append_html(pdf_document, html)
  end
end
