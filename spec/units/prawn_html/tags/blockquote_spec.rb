# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Blockquote do
  subject(:blockquote) { described_class.new(:blockquote) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for blockquote tag' do
      expect(blockquote.tag_styles).to eq(
        'margin-bottom' => described_class::MARGIN_BOTTOM.to_s,
        'margin-left' => described_class::MARGIN_LEFT.to_s,
        'margin-top' => described_class::MARGIN_TOP.to_s
      )
    end
  end

  describe '#block?' do
    subject(:block?) { blockquote.block? }

    it { is_expected.to be_truthy }
  end
end
