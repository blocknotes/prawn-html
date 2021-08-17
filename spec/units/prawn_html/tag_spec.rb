# frozen_string_literal: true

RSpec.describe PrawnHtml::Tag do
  subject(:tag) { described_class.new(:some_tag, attributes) }

  let(:attributes) { { 'style' => 'color: 0088ff' } }

  describe '#initialize' do
    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_call_original
    end

    it 'instantiates a new Attributes object', :aggregate_failures do
      tag
      expect(PrawnHtml::Attributes).to have_received(:new).with('style' => 'color: 0088ff')
      expect(tag.attrs).to be_kind_of(PrawnHtml::Attributes)
    end

    it 'sets the tag' do
      expect(tag.tag).to eq(:some_tag)
    end
  end

  describe '#block?' do
    subject(:block?) { tag.block? }

    it { is_expected.to be_falsey }
  end

  describe '#block_styles' do
    subject(:block_styles) { tag.block_styles }

    it { is_expected.to eq({}) }

    context 'with some data attributes' do
      let(:attributes) { { 'data-mode' => 'mode1' } }

      it 'delegates to the tag attributes' do
        expect(block_styles).to eq(mode: :mode1)
      end
    end
  end

  describe '#styles' do
    subject(:styles) { tag.styles }

    it { is_expected.to eq(color: '0088ff') }
  end

  describe '#tag_close_styles' do
    subject(:tag_close_styles) { tag.tag_close_styles }

    it { is_expected.to eq({}) }
  end

  describe '#tag_open_styles' do
    subject(:tag_open_styles) { tag.tag_open_styles }

    it { is_expected.to eq({}) }
  end

  describe '.class_for' do
    subject(:class_for) { described_class.class_for(tag_name) }

    context 'with an unknown tag name' do
      let(:tag_name) { :some_tag }

      it { is_expected.to be_nil }
    end

    context 'with an h6 tag' do
      let(:tag_name) { :h6 }

      it { is_expected.to eq(PrawnHtml::Tags::H) }
    end
  end
end
