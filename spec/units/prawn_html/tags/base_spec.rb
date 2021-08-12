# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Base do
  subject(:base) { described_class.new(:some_tag, 'style' => 'color: 0088ff') }

  describe '#initialize' do
    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_call_original
    end

    it 'instantiates a new Attributes object', :aggregate_failures do
      base
      expect(PrawnHtml::Attributes).to have_received(:new).with('style' => 'color: 0088ff')
      expect(base.attrs).to be_kind_of(PrawnHtml::Attributes)
    end

    it 'sets the tag' do
      expect(base.tag).to eq(:some_tag)
    end
  end

  describe '#apply_doc_styles' do
    subject(:apply_doc_styles) { base.apply_doc_styles(document_styles) }

    let(:document_styles) { { 'some_tag' => { 'text-align': 'center' } } }

    it 'merges the document styles' do
      apply_doc_styles
      expect(base.styles).to match(color: '0088ff', 'text-align': 'center')
    end

    context 'with a style already present in the tag' do
      let(:document_styles) { { 'some_tag' => { color: 'ffbb11', 'font-weight': 'bold' } } }

      it 'merges the document styles' do
        apply_doc_styles
        expect(base.styles).to match(color: '0088ff', 'font-weight': 'bold')
      end
    end
  end

  describe '#block?' do
    subject(:block?) { base.block? }

    it { is_expected.to be_falsey }
  end

  describe '#extra_attrs' do
    subject(:extra_attrs) { base.extra_attrs }

    it { is_expected.to eq({}) }
  end

  describe '#options' do
    subject(:options) { base.options }

    let(:attributes) { instance_double(PrawnHtml::Attributes, styles: {}, options: :some_options) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(options).to eq(:some_options)
    end
  end

  describe '#post_styles' do
    subject(:post_styles) { base.post_styles }

    let(:attributes) { instance_double(PrawnHtml::Attributes, styles: {}, post_styles: :some_post_styles) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(post_styles).to eq(:some_post_styles)
    end
  end

  describe '#pre_styles' do
    subject(:pre_styles) { base.pre_styles }

    let(:attributes) { instance_double(PrawnHtml::Attributes, styles: {}, pre_styles: :some_pre_styles) }

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_return(attributes)
    end

    it 'delegates to the tag attributes' do
      expect(pre_styles).to eq(:some_pre_styles)
    end
  end

  describe '.elements' do
    subject(:elements) { described_class.elements }

    it 'raises a NameError' do
      expect { elements }.to raise_exception(NameError, 'uninitialized constant PrawnHtml::Tags::Base::ELEMENTS')
    end
  end
end
