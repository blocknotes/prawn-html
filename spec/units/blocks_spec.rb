# frozen_string_literal: true

RSpec.describe 'Blocks' do
  let(:pdf_doc) do
    TestUtils.styled_text_document(html) { |pdf| allow(pdf).to receive(:formatted_text) }
  end

  context 'with some content in an element div' do
    let(:html) { '<div>Some sample content...</div>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content..." }], {}
      )
    end
  end

  context 'with some content in an element p' do
    let(:html) { '<p>Some sample content...</p>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content..." }], {}
      )
    end
  end
end
