# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::B do
  subject(:b) { described_class.new(:b, attributes: { 'style' => 'color: ffbb11' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for b tag' do
      expect(b.tag_styles).to eq('font-weight' => 'bold')
    end
  end
end
