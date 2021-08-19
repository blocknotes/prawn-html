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

  describe 'when the parent is an ol element' do
    subject(:li) { described_class.new(:li) }

    let(:context) { instance_double(PrawnHtml::Context) }
    let(:parent) { PrawnHtml::Tags::Ol.new(:ol) }

    before do
      li.parent = parent
      li.on_context_add(context)
    end

    it 'sets the counter in before content' do
      expect(li.tag_styles).to eq(before_content: '1.  ')
    end
  end
end
