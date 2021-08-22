# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ol do
  subject(:ol) { described_class.new(:ol) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  it 'sets the counter to zero' do
    expect(ol.counter).to be_zero
  end

  context 'without attributes' do
    it 'returns the expected tag_styles for ol tag' do
      expect(ol.tag_styles).to eq('margin-left' => PrawnHtml::Tags::Ol::MARGIN_LEFT.to_s)
    end
  end

  describe '#block?' do
    subject(:block?) { ol.block? }

    it { is_expected.to be_truthy }
  end
end
