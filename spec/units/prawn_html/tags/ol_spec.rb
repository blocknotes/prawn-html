# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ol do
  subject(:ol) { described_class.new(:ol, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  it 'sets the counter to zero' do
    expect(ol.counter).to be_zero
  end

  context 'without attributes' do
    it 'returns the expected styles for ol tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_left: PrawnHtml::Utils.convert_size(described_class::MARGIN_LEFT.to_s),
      }
      expect(ol.styles).to match(expected_styles)
    end
  end

  describe '#block?' do
    subject(:block?) { ol.block? }

    it { is_expected.to be_truthy }
  end
end
