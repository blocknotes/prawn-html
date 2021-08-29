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
    subject(:process) { html_parser.process(html) }

    let(:html) { 'some text' }

    before do
      allow(Oga).to receive(:parse_html).and_call_original
    end

    it 'calls Oga parse html', :aggregate_failures do
      process
      expect(Oga).to have_received(:parse_html).with(html)
      expect(renderer).to have_received(:on_text_node).with(html)
    end
  end

  describe 'ignore some elements' do
    let(:process) { html_parser.process(html) }

    before do
      allow(Oga).to receive(:parse_html).and_call_original
      allow(PrawnHtml::IgnoredTag).to receive(:new).and_call_original
      allow(renderer).to receive(:on_tag_open)
    end

    context 'with an HTML comment' do
      let(:html) { 'before<!--> comment <b>bold</b> --> <i>italic</i>after' }

      it 'skips the HTML comments', :aggregate_failures do
        process
        expect(renderer).to have_received(:on_text_node).with('before').ordered
        expect(renderer).not_to have_received(:on_text_node).with('bold')
        expect(renderer).to have_received(:on_text_node).with('italic').ordered
        expect(renderer).to have_received(:on_text_node).with('after').ordered
      end
    end

    context 'with a script tag' do
      let(:html) { 'before<script>a script</script>after' }

      it 'skips the content of the script tag', :aggregate_failures do
        process
        expect(renderer).to have_received(:on_text_node).with('before').ordered
        expect(PrawnHtml::IgnoredTag).to have_received(:new).with(:script).ordered
        expect(renderer).not_to have_received(:on_text_node).with('a script')
        expect(renderer).to have_received(:on_text_node).with('after').ordered
      end
    end

    context 'with a style tag' do
      let(:html) { 'before<style>some styles</style>after' }

      before do
        allow(renderer).to receive(:on_tag_open)
      end

      it 'skips the content of style tag but parses the styles', :aggregate_failures do
        process
        expect(renderer).to have_received(:on_text_node).with('before').ordered
        expect(PrawnHtml::IgnoredTag).to have_received(:new).with(:style).ordered
        expect(renderer).not_to have_received(:on_text_node).with('some styles')
        expect(renderer).to have_received(:on_text_node).with('after').ordered
      end
    end
  end
end
