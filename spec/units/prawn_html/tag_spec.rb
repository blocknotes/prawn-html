# frozen_string_literal: true

RSpec.describe PrawnHtml::Tag do
  subject(:tag) { described_class.new(:some_tag, 'style' => 'color: 0088ff') }

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

  describe '#apply_doc_styles' do
    subject(:apply_doc_styles) { tag.apply_doc_styles(document_styles) }

    let(:document_styles) { { 'some_tag' => { 'text-align': 'center' } } }

    it 'merges the document styles' do
      apply_doc_styles
      expect(tag.styles).to match(color: '0088ff', 'text-align': 'center')
    end

    context 'with a style already present in the tag' do
      let(:document_styles) { { 'some_tag' => { color: 'ffbb11', 'font-weight': 'bold' } } }

      it 'merges the document styles' do
        apply_doc_styles
        expect(tag.styles).to match(color: '0088ff', 'font-weight': 'bold')
      end
    end
  end

  describe '#block?' do
    subject(:block?) { tag.block? }

    it { is_expected.to be_falsey }
  end

  describe '#extra_attrs' do
    subject(:extra_attrs) { tag.extra_attrs }

    it { is_expected.to eq({}) }
  end

  describe '#options' do
    subject(:options) { tag.options }

    let(:attributes) { instance_double(PrawnHtml::Attributes, data: {}, options: { opt1: 123 }, styles: {}) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(options).to eq(opt1: 123)
    end

    context 'with mode data attribute' do
      let(:attributes) do
        instance_double(PrawnHtml::Attributes, data: { 'mode' => 'some_mode' }, options: { opt1: 123 }, styles: {})
      end

      it 'merges the options' do
        expect(options).to eq(mode: :some_mode, opt1: 123)
      end
    end
  end

  describe '#post_styles' do
    subject(:post_styles) { tag.post_styles }

    let(:attributes) { instance_double(PrawnHtml::Attributes, styles: {}, post_styles: :some_post_styles) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(post_styles).to eq(:some_post_styles)
    end
  end

  describe '#pre_styles' do
    subject(:pre_styles) { tag.pre_styles }

    let(:attributes) { instance_double(PrawnHtml::Attributes, styles: {}, pre_styles: :some_pre_styles) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(pre_styles).to eq(:some_pre_styles)
    end
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
