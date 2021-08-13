# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Small do
  subject(:small) { described_class.new(:small, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  describe '#update_styles' do
    subject(:update_styles) { small.update_styles(styles) }

    let(:styles) { { some_attr: 'some_value' } }

    it 'updates the argument styles reducing the default font size' do
      expect(update_styles).to eq(some_attr: 'some_value', size: 8.755)
    end

    context 'with a parent font size' do
      let(:styles) { { some_attr: 'some_value', size: 20 } }

      it 'updates the argument styles reducing the current font size' do
        expect(update_styles).to eq(some_attr: 'some_value', size: 17.0)
      end
    end
  end
end
