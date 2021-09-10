# frozen_string_literal: true

RSpec.describe PrawnHtml::Context do
  subject(:context) { described_class.new }

  it { expect(described_class).to be < Array }

  describe '#initialize' do
    it 'last_text_node is set to false' do
      expect(context.last_text_node).to be_falsey
    end
  end

  describe '#add' do
    let(:some_tag_class) do
      Class.new(PrawnHtml::Tag) do
        def on_context_add(context)
          # extra init after context insertion
        end
      end
    end
    let(:tag1) { instance_double(PrawnHtml::Tag, 'parent=': true) }
    let(:tag2) { instance_double(some_tag_class, 'parent=': true, on_context_add: true) }

    it 'adds the elements', :aggregate_failures do
      expect { context.add(tag1) }.to change(context, :size).from(0).to(1)
      expect(tag1).to have_received('parent=').with(nil)

      expect { context.add(tag2) }.to change(context, :size).from(1).to(2)
      expect(tag2).to have_received(:'parent=').with(tag1)
      expect(tag2).to have_received(:on_context_add).with(context)
    end

    it 'returns the context itself' do
      expect(context.add(tag1)).to eq(context)
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
          def before_content
            'Some before content'
          end
        end
      end

      before do
        context << some_tag_class.new(:some_tag)
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

  describe '#remove_last' do
    subject(:remove_last) { context.remove_last }

    let(:some_tag_class) do
      Class.new(PrawnHtml::Tag) do
        def on_context_remove(context)
          # callback after removal
        end
      end
    end
    let(:tag) { instance_double(some_tag_class, on_context_remove: true, :parent= => true, tag: :some_tag) }

    before do
      context.add(tag)
    end

    it 'removes the last element from the context', :aggregate_failures do
      expect { remove_last }.to(
        change(context, :size).from(1).to(0).and(
          change(context, :previous_tag).from(nil).to(:some_tag)
        )
      )
      expect(tag).to have_received(:on_context_remove)
    end
  end

  describe '#merged_styles' do
    subject(:merged_styles) { context.merged_styles }

    context 'with no elements' do
      it { is_expected.to eq(size: PrawnHtml::Context::DEFAULT_STYLES[:size]) }
    end

    context 'with some elements' do
      let(:tag1) { instance_double(PrawnHtml::Tag, styles: { color: 'fb1', size: 12.34 }, update_styles: nil) }
      let(:tag2) { instance_double(PrawnHtml::Tag, styles: { color: 'abc' }, update_styles: nil) }

      before do
        context << tag1 << tag2
      end

      it 'merges the styles of the elements' do
        expect(merged_styles).to match(color: 'abc', size: 12.34)
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
      let(:tag1) { instance_double(PrawnHtml::Tag, styles: { color: 'fb1', size: 12.34 }, update_styles: nil) }
      let(:tag2) { some_tag_class.new(:some_tag) }

      before do
        allow(tag2).to receive(:update_styles).and_call_original
        context << tag1 << tag2
      end

      it 'sends the context styles to the update_styles method', :aggregate_failures do
        expect(merged_styles).to match(color: 'fb1', size: 12.34, some_style: :some_value)
        expect(tag2).to have_received(:update_styles)
      end
    end
  end
end
