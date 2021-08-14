# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::P do
  subject(:p) { described_class.new(:p, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected extra_attrs for p tag' do
      expect(p.extra_attrs).to eq(
        'margin-bottom' => PrawnHtml::Tags::P::MARGIN_BOTTOM.to_s,
        'margin-top' => PrawnHtml::Tags::P::MARGIN_TOP.to_s
      )
    end
  end

  describe '#block?' do
    subject(:block?) { p.block? }

    it { is_expected.to be_truthy }
  end
end
