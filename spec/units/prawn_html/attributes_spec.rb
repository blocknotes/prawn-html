# frozen_string_literal: true

RSpec.describe PrawnHtml::Attributes do
  subject(:attributes) { described_class.new(attributes_hash) }

  let(:attributes_hash) { { attr1: 'value 1', attr2: 'value 2' } }

  it { expect(described_class).to be < OpenStruct }

  describe '#initialize' do
    it 'returns an empty styles hash' do
      expect(attributes.styles).to eq({})
    end
  end

  describe '#data' do
    subject(:data) { attributes.data }

    context 'with some data attributes (data-dash: 5 and data-something-else: "some value")' do
      let(:attributes_hash) { { 'data-dash': '5', 'data-something-else': '"some value"' } }

      it { is_expected.to match('dash' => '5', 'something-else' => '"some value"') }
    end
  end

  describe '#merge_text_styles!' do
    subject(:merge_text_styles!) { attributes.merge_text_styles!(text_styles, options: options) }

    let(:options) { {} }

    before do
      allow(PrawnHtml::Utils).to receive(:send).and_call_original
    end

    context 'with an empty hash' do
      let(:text_styles) { '' }

      it "doesn't merge new styles" do
        expect(attributes.styles).to eq({})
      end
    end

    context 'with some styles' do
      let(:text_styles) do
        <<~STYLES
          font-family: 'Times-Roman';
          font-size: 16px;
          font-weight: bold;
          margin-bottom: 22px;
        STYLES
      end

      it 'receives the expected convert messages', :aggregate_failures do
        merge_text_styles!

        expect(PrawnHtml::Utils).to have_received(:send).with(:unquote, "'Times-Roman'", options: nil)
        expect(PrawnHtml::Utils).to have_received(:send).with(:convert_size, '16px', options: nil)
        expect(PrawnHtml::Utils).to have_received(:send).with(:convert_size, '22px', options: nil)
      end
    end

    context 'with some options' do
      let(:options) { { width: 540, height: 720 } }
      let(:text_styles) { 'top: 50%' }

      it 'receives the expected convert messages', :aggregate_failures do
        merge_text_styles!

        expect(PrawnHtml::Utils).to have_received(:send).with(:convert_size, '50%', options: 720)
      end
    end
  end

  describe '#remove_value' do
    subject(:remove_value) { attributes.remove_value(context_styles, rule) }

    let(:context_styles) { { size: 9.6, styles: %i[bold italic] } }

    context 'with a missing rule' do
      let(:rule) { { key: :color, set: :convert_color } }

      it "doesn't change the context styles" do
        expect { remove_value }.not_to change(context_styles, :values)
      end
    end

    context 'with an applied rule' do
      let(:rule) { { key: :styles, set: :append_styles, values: %i[bold] } }

      it "changes the context styles" do
        expect { remove_value }.to change(context_styles, :values).from([9.6, %i[bold italic]]).to([9.6, %i[italic]])
      end
    end
  end

  describe '.merge_attr!' do
    context 'with an empty key' do
      let(:key) { nil }
      let(:value) { '123' }

      it "doesn't update the hash" do
        hash = { some_key: 'some value' }
        described_class.merge_attr!(hash, key, value)

        expect(hash).to eq(some_key: 'some value')
      end
    end

    context 'with a mergeable key (ex. :margin_left)' do
      let(:key) { :margin_left }
      let(:value) { 10 }

      it 'updates the hash increasing the target attribute', :aggregate_failures do
        hash = { some_key: 'some value' }
        described_class.merge_attr!(hash, key, value)
        expect(hash).to eq(margin_left: value, some_key: 'some value')

        described_class.merge_attr!(hash, key, 5)
        expect(hash).to eq(margin_left: 15, some_key: 'some value')
      end
    end

    context 'with a non-mergeable key (ex. :another_key)' do
      let(:key) { :another_key }
      let(:value) { 10 }

      it 'replaces the target attribute value in the hash' do
        hash = { another_key: 5, some_key: 'some value' }
        described_class.merge_attr!(hash, key, value)

        expect(hash).to eq(another_key: 10, some_key: 'some value')
      end
    end
  end

  describe '.parse_styles' do
    subject(:parse_styles) { described_class.parse_styles(styles) }

    context 'with nil styles' do
      let(:styles) { nil }

      it { is_expected.to eq({}) }
    end

    context 'with an invalid styles string' do
      let(:styles) { 'a a a' }

      it { is_expected.to eq({}) }
    end

    context 'with a valid styles string' do
      let(:styles) { 'padding-left: 10px; padding-top: 20px; padding-bottom: 30px' }

      it 'parses the styles string and return an hash' do
        expected_hash = {
          'padding-bottom' => '30px',
          'padding-left' => '10px',
          'padding-top' => '20px'
        }

        expect(parse_styles).to match(expected_hash)
      end
    end
  end
end
