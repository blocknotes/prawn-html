# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Code do
  subject(:code) { described_class.new(:code, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected styles for code tag' do
      expect(code.styles).to match(color: 'ffbb11', font: 'Courier')
    end
  end
end
