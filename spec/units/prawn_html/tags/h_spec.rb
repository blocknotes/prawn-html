# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::H do
  subject(:h1) { described_class.new(:h1, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      h1.process_styles
    end

    it 'returns the expected styles for h1 tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_bottom: PrawnHtml::Utils.convert_size(described_class::MARGINS_BOTTOM[:h1].to_s),
        margin_top: PrawnHtml::Utils.convert_size(described_class::MARGINS_TOP[:h1].to_s),
        size: PrawnHtml::Utils.convert_size(described_class::SIZES[:h1].to_s),
        styles: [:bold]
      }
      expect(h1.styles).to match(expected_styles)
    end
  end

  describe '#block?' do
    subject(:block?) { h1.block? }

    it { is_expected.to be_truthy }
  end
end
