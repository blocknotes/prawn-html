# frozen_string_literal: true

RSpec.describe 'Blocks' do
  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, advance_cursor: true, puts: true) }

  before do
    allow(pdf).to receive(:bounds).and_return(OpenStruct.new(width: 0, height: 0))
    allow(PrawnHtml::PdfWrapper).to receive(:new).and_return(pdf)
    pdf_document = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    PrawnHtml.append_html(pdf_document, html)
  end

  context 'with some content in an element div' do
    let(:html) { '<div>Some sample content...</div>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content..." }], {}, { bounding_box: nil }
      )
    end
  end

  context 'with some content in an element p' do
    let(:html) { '<p>Some sample content...</p>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content..." }], {}, { bounding_box: nil }
      )
    end
  end
end
