# frozen_string_literal: true

RSpec.describe PrawnHtml::Attributes do
  subject(:attributes) { described_class.new(attributes_hash) }

  let(:attributes_hash) { { attr1: 'value 1', attr2: 'value 2' } }

  it { expect(described_class).to be < OpenStruct }

  describe '#initialize' do
    it 'returns an empty styles hash' do
      expect(attributes.styles).to eq({})
    end

    context 'with some styles' do
      let(:attributes_hash) { { 'style' => 'color: #fb1; font-weight: bold' } }

      it 'returns the parsed styles' do
        expect(attributes.styles).to eq(color: 'ffbb11', styles: [:bold])
      end
    end
  end

  describe '#data' do
    subject(:data) { attributes.data }

    context 'with some data attributes (data-dash: 5 and data-something-else: "some value")' do
      let(:attributes_hash) { { 'data-dash': '5', 'data-something-else': '"some value"' } }

      it { is_expected.to match('dash' => '5', 'something-else' => '"some value"') }
    end
  end

  describe '#merge_styles!' do
    subject(:merge_styles!) { attributes.merge_styles!(parsed_styles) }

    let(:attributes_hash) { { 'style' => 'font-size: 12px' } }
    let(:parsed_styles) { { color: 'fb1' } }

    it { is_expected.to match(color: 'fb1', size: 12 * PrawnHtml::PX) }
  end

  describe '#process_styles' do
    subject(:process_styles) { attributes.process_styles(hash_styles) }

    before do
      allow(PrawnHtml::Utils).to receive(:send).and_call_original
    end

    context 'with an empty hash' do
      let(:hash_styles) { {} }

      it { is_expected.to eq({}) }
    end

    context 'with some styles' do
      let(:hash_styles) do
        {
          'font-family' => "'Times-Roman'",
          'font-size' => "16px",
          'font-weight' => "bold",
          'margin-bottom' => "22px"
        }
      end

      it 'receives the expected convert messages', :aggregate_failures do
        process_styles

        expect(PrawnHtml::Utils).to have_received(:send).with(:unquote, "'Times-Roman'")
        expect(PrawnHtml::Utils).to have_received(:send).with(:convert_size, '16px')
        expect(PrawnHtml::Utils).to have_received(:send).with(:convert_size, '22px')
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
