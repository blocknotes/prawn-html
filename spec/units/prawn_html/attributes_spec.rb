# frozen_string_literal: true

RSpec.describe PrawnHtml::Attributes do
  subject(:attributes) { described_class.new(attributes_hash) }

  let(:attributes_hash) { { attr1: 'value 1', attr2: 'value 2' } }

  describe '#initialize' do
    before do
      allow(OpenStruct).to receive(:new).and_call_original
    end

    it 'stores the attributes hash in an open struct' do
      attributes
      expect(OpenStruct).to have_received(:new).with(attributes_hash)
    end
  end

  describe '#process_styles' do
    subject(:process_styles) { attributes.process_styles(hash_styles) }

    before do
      allow(described_class).to receive(:send).and_call_original
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

        expect(described_class).to have_received(:send).with(:unquote, "'Times-Roman'")
        expect(described_class).to have_received(:send).with(:convert_size, '16px')
        expect(described_class).to have_received(:send).with(:convert_size, '22px')
      end
    end
  end

  describe '.convert_color' do
    subject(:convert_color) { described_class.convert_color(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq '' }
    end

    context 'with a blank string value' do
      let(:value) { '' }

      it { is_expected.to eq '' }
    end

    context 'with a 3 characters string value (ex. "#A80")' do
      let(:value) { '#A80' }

      it { is_expected.to eq 'aa8800' }
    end

    context 'with a 6 characters string value (ex. "#12aB0f")' do
      let(:value) { '#12aB0f' }

      it { is_expected.to eq '12ab0f' }
    end
  end

  describe '.convert_float' do
    subject(:convert_float) { described_class.convert_float(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq 0.0 }
    end

    context 'with a blank string value' do
      let(:value) { '' }

      it { is_expected.to eq 0.0 }
    end

    context 'with a decimal value (ex. "10.12345")' do
      let(:value) { '10.12345' }

      it { is_expected.to eq 10.1235 }
    end

    context 'with an integer value (ex. "12345")' do
      let(:value) { '12345' }

      it { is_expected.to eq 12_345.0 }
    end
  end

  describe '.convert_size' do
    subject(:convert_size) { described_class.convert_size(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq 0.0 }
    end

    context 'with a blank string value' do
      let(:value) { '' }

      it { is_expected.to eq 0.0 }
    end

    context 'with a pixel value (ex. "10.125")' do
      let(:value) { '10.125' }

      it { is_expected.to eq 6.6825 }
    end

    context 'with a percentage value and a container size (ex. "50%" and 100.242424)' do
      subject(:convert_size) { described_class.convert_size(value, 100.242424) }

      let(:value) { '50%' }

      it { is_expected.to eq 50.1212 }
    end
  end

  describe '.convert_symbol' do
    subject(:convert_symbol) { described_class.convert_symbol(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq nil }
    end

    context 'with a blank string value' do
      let(:value) { '' }

      it { is_expected.to eq nil }
    end

    context 'with a string value (ex. "some_string")' do
      let(:value) { 'some_string' }

      it { is_expected.to eq :some_string }
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

  describe '.unquote' do
    subject(:unquote) { described_class.unquote(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq '' }
    end

    context 'with a blank string value' do
      let(:value) { '' }

      it { is_expected.to eq '' }
    end

    context 'with a string with some spaces (ex. " a string ")' do
      let(:value) { ' a string ' }

      it { is_expected.to eq 'a string' }
    end

    context 'with a string with some single quotes (ex. " \' a \' string \' ")' do
      let(:value) { " ' a ' string ' " }

      it { is_expected.to eq " a ' string " }
    end

    context 'with a string with some double quotes (ex. " \" a \" string \" ")' do
      let(:value) { ' " a " string " ' }

      it { is_expected.to eq ' a " string ' }
    end
  end
end
