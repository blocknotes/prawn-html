# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Hr do
  subject(:hr) { described_class.new(:hr, attributes: { 'style' => 'color: #fb1' }) }

  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, horizontal_rule: true) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { hr.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { hr.custom_render(pdf, context) }

    before do
      hr.process_styles
    end

    let(:context) { nil }

    it 'calls horizontal_rule on the pdf wrapper' do
      custom_render
      expect(pdf).to have_received(:horizontal_rule).with(color: 'ffbb11', dash: nil)
    end

    context 'with a dash number set' do
      subject(:hr) { described_class.new(:hr, attributes: { 'data-dash' => '5' }) }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: nil, dash: 5)
      end
    end

    context 'with a dash array set' do
      subject(:hr) { described_class.new(:hr, attributes: { 'data-dash' => '1, 2, 3' }) }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: nil, dash: [1, 2, 3])
      end
    end

    context 'with a color set via style attributes' do
      subject(:hr) { described_class.new(:hr, attributes: { 'style' => 'color: red' }) }

      it 'calls the color methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: 'ff0000', dash: nil)
      end
    end
  end

  context 'without attributes' do
    before do
      hr.process_styles
    end

    it 'returns the expected styles for hr tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_bottom: PrawnHtml::Utils.convert_size(described_class::MARGIN_BOTTOM.to_s),
        margin_top: PrawnHtml::Utils.convert_size(described_class::MARGIN_TOP.to_s)
      }
      expect(hr.styles).to match(expected_styles)
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { 'Some content<hr>More content' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf', :aggregate_failures do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some content" }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "More content" }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end
end
