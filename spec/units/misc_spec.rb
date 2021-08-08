# frozen_string_literal: true

RSpec.describe 'Misc' do
  let(:pdf_doc) do
    TestUtils.styled_text_document(html) { |pdf| allow(pdf).to receive(:formatted_text) }
  end

  context 'with an hr element' do
    let(:html) { 'Some content<hr>More content' }

    it 'sends the expected buffer elements to Prawn pdf', :aggregate_failures do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "Some content" }], {}
      )
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "More content" }], {}
      )
    end
  end

  context 'with an a element' do
    let(:html) { '<a href="https://www.google.it">A link</a>' }
    let(:expected_buffer) { [{ size: TestUtils.default_font_size, text: 'A link', link: 'https://www.google.it' }] }
    let(:expected_options) { {} }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(expected_buffer, expected_options)
    end
  end

  context 'with br elements' do
    let(:html) { 'First line<br>Second line<br/>Third line' }

    it 'sends the expected buffer elements to Prawn pdf', :aggregate_failures do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "First line" }], {}
      )
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "Second line" }], {}
      )
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: "Third line" }], {}
      )
    end
  end

  context 'with some content in an element b' do
    let(:html) { '<b>Some content...</b>' }
    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:bold], text: 'Some content...' }] }
    let(:expected_options) { {} }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(expected_buffer, expected_options)
    end
  end

  context 'with some content in an element del' do
    let(:html) { '<del>Some content...</del>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [hash_including(callback: anything, size: TestUtils.default_font_size, text: 'Some content...')], {}
      )
    end
  end

  context 'with some content in an element em' do
    let(:html) { '<em>Some content...</em>' }
    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:italic], text: 'Some content...' }] }
    let(:expected_options) { {} }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(expected_buffer, expected_options)
    end
  end

  context 'with some content in an element i' do
    let(:html) { '<i>Some content...</i>' }
    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:italic], text: 'Some content...' }] }
    let(:expected_options) { {} }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(expected_buffer, expected_options)
    end
  end

  context 'with some content in an element ins' do
    let(:html) { '<ins>Some content...</ins>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, styles: [:underline], text: 'Some content...' }], {}
      )
    end
  end

  context 'with some content in an element mark' do
    let(:html) { '<mark>Some content...</mark>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [hash_including(callback: anything, size: TestUtils.default_font_size, text: 'Some content...')], {}
      )
    end
  end

  context 'with some content in an element s' do
    let(:html) { '<s>Some content...</s>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [hash_including(callback: anything, size: TestUtils.default_font_size, text: 'Some content...')], {}
      )
    end
  end

  context 'with some content in an element small' do
    let(:html) { '<small>Some content...</small>' }
    let(:size) { PrawnHtml::Context::DEF_FONT_SIZE * 0.85 }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with([{ size: size, text: 'Some content...' }], {})
    end
  end

  context 'with some content in an element span' do
    let(:html) { '<span>Some content...</span>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, text: 'Some content...' }], {}
      )
    end
  end

  context 'with some content in an element strong' do
    let(:html) { '<strong>Some content...</strong>' }
    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:bold], text: 'Some content...' }] }
    let(:expected_options) { {} }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(expected_buffer, expected_options)
    end
  end

  context 'with some content in an element u' do
    let(:html) { '<u>Some content...</u>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf_doc).to have_received(:formatted_text).with(
        [{ size: TestUtils.default_font_size, styles: [:underline], text: 'Some content...' }], {}
      )
    end
  end
end
