# frozen_string_literal: true

RSpec.describe PrawnHtml::HtmlParser do
  subject(:html_parser) { described_class.new(renderer) }

  let(:renderer) { instance_double(PrawnHtml::DocumentRenderer, flush: true, on_text_node: nil) }

  describe 'REGEXP_STYLES' do
    subject(:regexp) { text.scan(described_class::REGEXP_STYLES) }

    context 'with a single rule and a single property: "i{color:red}"' do
      let(:text) { 'i{color:red}' }

      it { is_expected.to match_array [['i', 'color:red']] }
    end

    context 'with a single rule and more properties: "i { color: red; font-style: italic; font-weight: bold }"' do
      let(:text) { 'i { color: red; font-style: italic; font-weight: bold }' }

      it { is_expected.to match_array [['i', 'color: red; font-style: italic; font-weight: bold']] }
    end

    context 'with some rules' do
      let(:text) do
        <<~CSS
          i {
            color: red;
            font-style: italic; font-weight: bold
          }
          b { font-size: 20px; }
          u {
            color: RGB(128, 128, 128);
          }
        CSS
      end

      it { is_expected.to match_array [["i", "color: red;\n  font-style: italic; font-weight: bold"], ["b", "font-size: 20px;"], ["u", "color: RGB(128, 128, 128);"]] }
    end
  end

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
