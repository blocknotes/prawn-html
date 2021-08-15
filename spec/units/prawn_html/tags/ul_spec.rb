# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ul do
  subject(:ul) { described_class.new(:ul) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for ul tag' do
      expect(ul.tag_styles).to eq('margin-left' => PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
    end
  end

  describe '#block?' do
    subject(:block?) { ul.block? }

    it { is_expected.to be_truthy }
  end
end
