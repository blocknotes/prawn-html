# frozen_string_literal: true

RSpec.describe PrawnHtml::HtmlHandler do
  subject(:html_handler) { described_class.new(pdf_doc) }

  let(:pdf_doc) { instance_double(Prawn::Document) }

  describe '#process' do
    subject(:process) { html_handler.process('some html') }

    before do
      allow(Oga).to receive(:parse_html).and_call_original
    end

    it 'calls Oga parse html', :aggregate_failures do
      process
      expect(Oga).to have_received(:parse_html).with('some html')
    end
  end
end
