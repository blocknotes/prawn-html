# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::P do
  subject(:p) { described_class.new(:p, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

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

  describe '#block?' do
    subject(:block?) { p.block? }

    it { is_expected.to be_truthy }
  end
end
