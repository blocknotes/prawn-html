# frozen_string_literal: true

RSpec.describe PrawnHtml::Context do
  subject(:context) { described_class.new }

  it { expect(described_class).to be < Array }

  describe '#initialize' do
    it 'last_margin is set to 0' do
      expect(context.last_margin).to be_zero
    end

    it 'last_text_node is set to false' do
      expect(context.last_text_node).to be_falsey
    end
  end

  describe '#before_content' do
    subject(:before_content) { context.before_content }

    context 'with no elements' do
      it { is_expected.to eq '' }
    end

    context 'with the last element that has no tag_styles' do
      before do
        context << PrawnHtml::Tag.new(:some_tag)
      end

      it { is_expected.to eq '' }
    end

    context 'with the last element that has some tag_styles' do
      let(:some_tag_class) do
        Class.new(PrawnHtml::Tag) do
          def tag_styles
            {
              before_content: 'Some before content'
            }
          end
        end
      end
      let(:tag) { some_tag_class.new(:some_tag) }

      before do
        context << tag
      end

      it { is_expected.to eq 'Some before content' }
    end
  end

  describe '#block_styles' do
    subject(:block_styles) { context.block_styles }

    context 'with no elements' do
      it { is_expected.to eq({}) }
    end

    context 'with some elements' do
      let(:tag1) { instance_double(PrawnHtml::Tag, block_styles: { margin_left: 11.11 }) }
      let(:tag2) { instance_double(PrawnHtml::Tag, block_styles: { margin_left: 22.22 }) }

      before do
        allow(PrawnHtml::Attributes).to receive(:merge_attr!).and_call_original
        context << tag1 << tag2
      end

      it 'merges the block styles of the elements', :aggregate_failures do
        expect(block_styles).to eq(margin_left: 33.33)
        expect(PrawnHtml::Attributes).to have_received(:merge_attr!).twice
      end
    end
  end

  describe '#text_node_styles' do
    subject(:text_node_styles) { context.text_node_styles }

    context 'with no elements' do
      it { is_expected.to eq(size: PrawnHtml::Context::DEF_FONT_SIZE) }
    end

    context 'with some elements' do
      let(:tag1) { instance_double(PrawnHtml::Tag, styles: { color: 'fb1', size: 12.34 }) }
      let(:tag2) { instance_double(PrawnHtml::Tag, styles: { color: 'abc' }) }

      before do
        context << tag1 << tag2
      end

      it 'merges the styles of the elements' do
        expect(text_node_styles).to match(color: 'abc', size: 12.34)
      end
    end

    context 'with an element with update_styles' do
      let(:some_tag_class) do
        Class.new(PrawnHtml::Tag) do
          def update_styles(res)
            res[:some_style] = :some_value
          end
        end
      end
      let(:tag1) { instance_double(PrawnHtml::Tag, styles: { color: 'fb1', size: 12.34 }) }
      let(:tag2) { some_tag_class.new(:some_tag) }

      before do
        allow(tag2).to receive(:update_styles).and_call_original
        context << tag1 << tag2
      end

      it 'sends the context styles to the update_styles method', :aggregate_failures do
        expect(text_node_styles).to match(color: 'fb1', size: 12.34, some_style: :some_value)
        expect(tag2).to have_received(:update_styles)
      end
    end
  end
end
