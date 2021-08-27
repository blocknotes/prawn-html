# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Sup do
  subject(:sup) { described_class.new(:sup, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected styles for sup tag' do
      expect(sup.styles).to match(color: 'ffbb11', styles: [:superscript])
    end
  end
end
