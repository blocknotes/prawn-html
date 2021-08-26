# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::I do
  subject(:i) { described_class.new(:i, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected styles for i tag' do
      expect(i.styles).to match(color: 'ffbb11', styles: [:italic])
    end
  end
end
