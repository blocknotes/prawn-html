# frozen_string_literal: true

RSpec.describe PrawnHtml::Utils do
  describe '.callback_background' do
    subject(:callback_background) { described_class.callback_background(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to eq ['Highlight', nil] }
    end

    context 'with a color value' do
      let(:value) { 'red' }

      it { is_expected.to eq ['Highlight', 'ff0000'] }
    end
  end

  describe '.callback_strike_through' do
    subject(:callback_strike_through) { described_class.callback_strike_through(nil) }

    it { is_expected.to eq ['StrikeThrough', nil] }
  end

  describe '.convert_color' do
    subject(:convert_color) { described_class.convert_color(value) }

    context 'with a nil value' do
      let(:value) { nil }

      it { is_expected.to be_nil }
    end

    context 'with an invalid value' do
      let(:value) { ' unknown color ' }

      it { is_expected.to be_nil }
    end

    context 'with a 3 characters string value (ex. "#A80")' do
      let(:value) { ' #A80' }

      it { is_expected.to eq 'aa8800' }
    end

    context 'with a 6 characters string value (ex. "#12aB0f")' do
      let(:value) { '#12aB0f ' }

      it { is_expected.to eq '12ab0f' }
    end

    context 'with an RGB value (ex. "RGB(192, 0, 255)")' do
      let(:value) { 'RGB(192, 0, 255)' }

      it { is_expected.to eq 'c000ff' }
    end

    context 'with a color name (ex. "rebeccapurple")' do
      let(:value) { ' rebeccapurple ' }

      it { is_expected.to eq '663399' }
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
      subject(:convert_size) { described_class.convert_size(value, options: 100.242424) }

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

  describe '.copy_value' do
    subject(:copy_value) { described_class.copy_value(value) }

    context 'with any value (ex. "some_string")' do
      let(:value) { 'some_string' }

      it { is_expected.to eq 'some_string' }
    end
  end

  describe '.normalize_style' do
    subject(:normalize_style) { described_class.normalize_style(value) }

    context 'with an invalid value (ex. "some_string")' do
      let(:value) { 'some_string' }

      it { is_expected.to eq nil }
    end

    context 'with a valid value (ex. " bOlD ")' do
      let(:value) { ' bOlD ' }

      it { is_expected.to eq :bold }
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
