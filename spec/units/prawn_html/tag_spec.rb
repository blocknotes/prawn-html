# frozen_string_literal: true

RSpec.describe PrawnHtml::Tag do
  subject(:tag) { described_class.new(:some_tag, attributes: attributes) }

  let(:attributes) { { 'style' => 'color: #0088ff', 'some_attr' => 'some value' } }

  describe '#initialize' do
    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_call_original
    end

    it 'instantiates a new Attributes object', :aggregate_failures do
      tag
      expect(PrawnHtml::Attributes).to have_received(:new).with(attributes)
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

  describe '#process_styles' do
    subject(:process_styles) { tag.process_styles(element_styles: element_styles) }

    let(:element_styles) { nil }

    before do
      allow(tag.attrs).to receive(:merge_text_styles!)
    end

    it 'merges the inline styles' do
      process_styles
      expect(tag.attrs).to have_received(:merge_text_styles!).with('color: #0088ff', options: {})
    end

    context 'with some additional styles' do
      let(:some_tag_class) do
        Class.new(described_class) do
          def extra_styles
            'color: green; text-decoration: underline'
          end

          def tag_styles
            'color: yellow; font-style: italic'
          end
        end
      end

      let(:element_styles) { 'color: red; font-weight: bold' }
      let(:tag) { some_tag_class.new(:some_tag, attributes: attributes) }

      it 'merges the tag styles', :aggregate_failures do
        process_styles

        expected_styles = 'color: yellow; font-style: italic'
        expect(tag.attrs).to have_received(:merge_text_styles!).with(expected_styles, options: {}).ordered
        expect(tag.attrs).to have_received(:merge_text_styles!).with(element_styles, options: {}).ordered
        expect(tag.attrs).to have_received(:merge_text_styles!).with('color: #0088ff', options: {}).ordered
        expected_styles = 'color: green; text-decoration: underline'
        expect(tag.attrs).to have_received(:merge_text_styles!).with(expected_styles, options: {}).ordered
      end
    end
  end

  describe '#styles' do
    subject(:styles) { tag.styles }

    before do
      tag.process_styles
    end

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

  describe '#update_styles' do
    subject(:update_styles) { tag.update_styles(context_styles) }

    let(:context_styles) { { size: 9.6 } }

    before do
      allow(tag.attrs).to receive(:update_styles)
    end

    it 'asks to the attributes to update the context styles' do
      update_styles
      expect(tag.attrs).to have_received(:update_styles).with(context_styles)
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
