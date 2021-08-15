# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::U do
  subject(:u) { described_class.new(:u, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for u tag' do
      expect(u.tag_styles).to eq('text-decoration' => 'underline')
    end
  end
end
