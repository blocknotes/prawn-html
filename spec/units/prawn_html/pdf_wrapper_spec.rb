# frozen_string_literal: true

RSpec.describe PrawnHtml::PdfWrapper do
  subject(:pdf_wrapper) { described_class.new(pdf) }

  let(:pdf) { instance_double(Prawn::Document, formatted_text: true, image: true) }

  it 'delegates some methods to the pdf instance', :aggregate_failures do
    pdf_wrapper.formatted_text([])
    pdf_wrapper.image('some_image')
    expect(pdf).to have_received(:formatted_text).with([])
    expect(pdf).to have_received(:image).with('some_image')
  end

  describe '#advance_cursor' do
    subject(:advance_cursor) { pdf_wrapper.advance_cursor(quantity) }

    before do
      allow(pdf).to receive(:move_down)
    end

    context 'with some quantity' do
      let(:quantity) { 20 }

      it do
        advance_cursor
        expect(pdf).to have_received(:move_down).with(20)
      end
    end

    context 'with zero quantity' do
      let(:quantity) { 0 }

      it do
        advance_cursor
        expect(pdf).not_to have_received(:move_down).with(20)
      end
    end
  end
end
