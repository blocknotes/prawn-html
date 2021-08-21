# frozen_string_literal: true

RSpec.describe PrawnHtml::PdfWrapper do
  subject(:pdf_wrapper) { described_class.new(pdf) }

  let(:pdf) { instance_double(Prawn::Document, bounds: true, formatted_text: true, image: true) }

  it 'delegates some methods to the pdf instance', :aggregate_failures do
    pdf_wrapper.bounds
    pdf_wrapper.image('some_image')
    expect(pdf).to have_received(:bounds)
    expect(pdf).to have_received(:image).with('some_image')
  end

  describe '#advance_cursor' do
    subject(:advance_cursor) { pdf_wrapper.advance_cursor(quantity) }

    before do
      allow(pdf).to receive(:move_down)
    end

    context 'with some quantity' do
      let(:quantity) { 20 }

      it 'delegates to PDF move_down' do
        advance_cursor
        expect(pdf).to have_received(:move_down).with(20)
      end
    end

    context 'with zero quantity' do
      let(:quantity) { 0 }

      it "doesn't move down" do
        advance_cursor
        expect(pdf).not_to have_received(:move_down).with(20)
      end
    end
  end

  describe '#puts' do
    subject(:puts) { pdf_wrapper.puts(buffer, options, bounding_box: bounding_box) }

    let(:bounding_box) { nil }
    let(:buffer) { [] }
    let(:options) { {} }

    it 'calls the PDF formatted_text method' do
      puts
      expect(pdf).to have_received(:formatted_text).with(buffer, options)
    end
  end
end
