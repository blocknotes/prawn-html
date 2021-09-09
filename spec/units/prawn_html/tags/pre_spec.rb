# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Pre do
  subject(:pre) { described_class.new(:pre, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      pre.process_styles
    end

    it 'returns the expected styles for pre tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_bottom: PrawnHtml::Utils.convert_size(described_class::MARGIN_BOTTOM.to_s),
        margin_top: PrawnHtml::Utils.convert_size(described_class::MARGIN_TOP.to_s),
        font: 'Courier',
        white_space: :pre
      }
      expect(pre.styles).to match(expected_styles)
    end
  end

  describe '#block?' do
    subject(:block?) { pre.block? }

    it { is_expected.to be_truthy }
  end
end
