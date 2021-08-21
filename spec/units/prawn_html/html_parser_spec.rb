# frozen_string_literal: true

RSpec.describe PrawnHtml::HtmlParser do
  subject(:html_parser) { described_class.new(renderer) }

  let(:renderer) { instance_double(PrawnHtml::DocumentRenderer, flush: true, on_text_node: nil) }

  describe '#process' do
    subject(:process) { html_parser.process('some html') }

    before do
      allow(Oga).to receive(:parse_html).and_call_original
    end

    it 'calls Oga parse html', :aggregate_failures do
      process
      expect(Oga).to have_received(:parse_html).with('some html')
      expect(renderer).to have_received(:on_text_node)
    end
  end
end
