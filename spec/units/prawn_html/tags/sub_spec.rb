# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Sub do
  subject(:sub) { described_class.new(:sub, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      sub.process_styles
    end

    it 'returns the expected styles for sub tag' do
      expect(sub.styles).to match(color: 'ffbb11', styles: [:subscript])
    end
  end
end
