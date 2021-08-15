# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Li do
  subject(:li) { described_class.new(:li, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { li.block? }

    it { is_expected.to be_truthy }
  end

  describe '#tag_styles' do
    subject(:tag_styles) { li.tag_styles }

    it 'merges the before_content property into tag_styles' do
      expect(tag_styles).to match(before_content: '&bullet;  ')
    end
  end
end
