# frozen_string_literal: true

RSpec.describe 'Lists' do
  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, advance_cursor: true, puts: true) }

  before do
    allow(pdf).to receive_messages(page_width: 540, page_height: 720)
    allow(PrawnHtml::PdfWrapper).to receive(:new).and_return(pdf)
    pdf_document = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    PrawnHtml.append_html(pdf_document, html)
  end

  context 'with an ul list' do
    let(:html) do
      <<~HTML
        <ul>
          <li>First item</li>
          <li>Second item</li>
          <li>Third item</li>
        </ul>
      HTML
    end
    let(:size) { TestUtils.default_font_size }
    let(:margin_left) do
      PrawnHtml::Utils.convert_size(PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
    end

    it 'sends the expected buffer elements to Prawn pdf', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• First item" }],
        { indent_paragraphs: margin_left, leading: TestUtils.adjust_leading },
        { bounding_box: nil }
      )
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• Second item" }],
        { indent_paragraphs: margin_left, leading: TestUtils.adjust_leading },
        { bounding_box: nil }
      )
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• Third item" }],
        { indent_paragraphs: margin_left, leading: TestUtils.adjust_leading },
        { bounding_box: nil }
      )
    end
  end
end
