# frozen_string_literal: true

RSpec.describe PrawnHtml::Instance do
  describe 'initialize' do
    subject(:instance) { described_class.new(pdf) }

    let(:pdf) { instance_double(Prawn::Document) }

    before do
      allow(PrawnHtml::PdfWrapper).to receive(:new)
      allow(PrawnHtml::DocumentRenderer).to receive(:new)
      allow(PrawnHtml::HtmlParser).to receive(:new)
    end

    it 'initializes the required entities', :aggregate_failures do
      instance
      expect(PrawnHtml::PdfWrapper).to have_received(:new)
      expect(PrawnHtml::DocumentRenderer).to have_received(:new)
      expect(PrawnHtml::HtmlParser).to have_received(:new)
    end
  end

  describe '#append' do
    subject(:append) { described_class.new(pdf).append(html: html) }

    let(:html) { '<h1>Some HTML</h1>' }
    let(:html_parser) { instance_double(PrawnHtml::HtmlParser, process: nil) }
    let(:pdf) { instance_double(Prawn::Document) }

    before do
      allow(PrawnHtml::HtmlParser).to receive(:new).and_return(html_parser)
    end

    it 'sends a process message to the html parser' do
      append
      expect(html_parser).to have_received(:process).with(html)
    end
  end
end
