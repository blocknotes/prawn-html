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
end
