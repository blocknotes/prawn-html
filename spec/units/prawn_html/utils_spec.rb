# frozen_string_literal: true

RSpec.describe PrawnHtml::Utils do
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

  describe '.copy' do
    subject(:copy) { described_class.copy(value) }

    context 'with any value (ex. "some_string")' do
      let(:value) { 'some_string' }

      it { is_expected.to eq 'some_string' }
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
