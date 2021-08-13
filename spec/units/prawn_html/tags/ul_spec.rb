# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ul do
  subject(:ul) { described_class.new(:ul) }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  context 'without attributes' do
    it 'returns the expected extra_attrs for ul tag' do
      expect(ul.extra_attrs).to eq('margin-left' => PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
    end
  end

  describe '#block?' do
    subject(:block?) { ul.block? }

    it { is_expected.to be_truthy }
  end
end
