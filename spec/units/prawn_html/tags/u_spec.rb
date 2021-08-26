# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::U do
  subject(:u) { described_class.new(:u, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected styles for u tag' do
      expect(u.styles).to match(color: 'ffbb11', styles: [:underline])
    end
  end
end
