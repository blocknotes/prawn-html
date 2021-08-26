# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::B do
  subject(:b) { described_class.new(:b, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected styles for b tag' do
      expect(b.styles).to match(color: 'ffbb11', styles: [:bold])
    end
  end
end
