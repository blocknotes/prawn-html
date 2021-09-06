# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::P do
  subject(:p) { described_class.new(:p, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { p.block? }

    it { is_expected.to be_truthy }
  end

  context 'without attributes' do
    before do
      p.process_styles
    end

    it 'returns the expected styles for p tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_bottom: PrawnHtml::Utils.convert_size(described_class::MARGIN_BOTTOM.to_s),
        margin_top: PrawnHtml::Utils.convert_size(described_class::MARGIN_TOP.to_s)
      }
      expect(p.styles).to match(expected_styles)
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<p>Some sample content</p>' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content" }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end
end
