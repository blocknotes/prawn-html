# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ul do
  subject(:ul) { described_class.new(:ul, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      ul.process_styles
    end

    it 'returns the expected styles for ul tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_left: PrawnHtml::Utils.convert_size(described_class::MARGIN_LEFT.to_s),
      }
      expect(ul.styles).to match(expected_styles)
    end
  end

  describe '#block?' do
    subject(:block?) { ul.block? }

    it { is_expected.to be_truthy }
  end
end
