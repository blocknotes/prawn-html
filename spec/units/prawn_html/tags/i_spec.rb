# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::I do
  subject(:i) { described_class.new(:i, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  context 'without attributes' do
    it 'returns the expected extra_attrs for i tag' do
      expect(i.extra_attrs).to eq('font-style' => 'italic')
    end
  end
end
