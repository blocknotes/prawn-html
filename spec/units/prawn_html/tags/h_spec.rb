# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::H do
  subject(:h1) { described_class.new(:h1, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  context 'without attributes' do
    it 'returns the expected extra_attrs for h1 tag' do
      expect(h1.extra_attrs).to eq(
        'font-size' => PrawnHtml::Tags::H::SIZES[:h1].to_s,
        'font-weight' => 'bold',
        'margin-bottom' => PrawnHtml::Tags::H::MARGINS_BOTTOM[:h1].to_s,
        'margin-top' => PrawnHtml::Tags::H::MARGINS_TOP[:h1].to_s
      )
    end
  end

  describe '#block?' do
    subject(:block?) { h1.block? }

    it { is_expected.to be_truthy }
  end
end
