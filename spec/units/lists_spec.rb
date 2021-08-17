# frozen_string_literal: true

RSpec.describe 'Lists' do
  let(:pdf_doc) do
    TestUtils.styled_text_document(html) do |pdf|
      allow(pdf).to receive(:indent).and_call_original
      allow(pdf).to receive(:formatted_text)
    end
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
      PrawnHtml::Attributes.convert_size(PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
    end

    it 'sends the expected buffer elements to Prawn pdf', :aggregate_failures do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: size, text: "•  First item" }], { indent_paragraphs: margin_left }
      )
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: size, text: "•  Second item" }], { indent_paragraphs: margin_left }
      )
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: size, text: "•  Third item" }], { indent_paragraphs: margin_left }
      )
    end
  end
end
