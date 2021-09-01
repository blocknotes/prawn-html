# frozen_string_literal: true

RSpec.describe 'Headings' do
  let(:expected_buffer) { [{ size: size, styles: [:bold], text: 'Some sample content...' }] }
  let(:expected_options) { {} }
  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, advance_cursor: true, puts: true) }

  before do
    allow(pdf).to receive_messages(page_width: 540, page_height: 720)
    allow(PrawnHtml::PdfWrapper).to receive(:new).and_return(pdf)
    pdf_document = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    PrawnHtml.append_html(pdf_document, html)
  end

  context 'with some content in an element h1' do
    let(:html) { '<h1>Some sample content...</h1>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h1].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end

  context 'with some content in an element h2' do
    let(:html) { '<h2>Some sample content...</h2>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h2].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end

  context 'with some content in an element h3' do
    let(:html) { '<h3>Some sample content...</h3>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h3].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end

  context 'with some content in an element h4' do
    let(:html) { '<h4>Some sample content...</h4>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h4].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end

  context 'with some content in an element h5' do
    let(:html) { '<h5>Some sample content...</h5>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h5].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end

  context 'with some content in an element h6' do
    let(:html) { '<h6>Some sample content...</h6>' }
    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h6].to_s) }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, bounding_box: nil)
    end
  end
end
