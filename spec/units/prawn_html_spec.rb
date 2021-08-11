# frozen_string_literal: true

RSpec.describe PrawnHtml do
  describe '.append_html' do
    subject(:append_html) { described_class.append_html(pdf, html) }

    let(:pdf) { instance_double(Prawn::Document) }
    let(:html) { '<div>some html</div>' }
    let(:html_handler) { instance_double(PrawnHtml::HtmlHandler, process: true) }

    before do
      allow(PrawnHtml::HtmlHandler).to receive(:new).and_return(html_handler)
    end

    it 'creates an instance of PrawnHtml::HtmlHandler and call process', :aggregate_failures do
      append_html
      expect(PrawnHtml::HtmlHandler).to have_received(:new).with(pdf)
      expect(html_handler).to have_received(:process).with(html)
    end
  end
end
