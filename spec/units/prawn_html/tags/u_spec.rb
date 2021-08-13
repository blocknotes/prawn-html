# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::U do
  subject(:u) { described_class.new(:u, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  context 'without attributes' do
    it 'returns the expected extra_attrs for u tag' do
      expect(u.extra_attrs).to eq('text-decoration' => 'underline')
    end
  end
end
