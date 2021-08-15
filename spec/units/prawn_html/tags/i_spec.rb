# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::I do
  subject(:i) { described_class.new(:i, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for i tag' do
      expect(i.tag_styles).to eq('font-style' => 'italic')
    end
  end
end
