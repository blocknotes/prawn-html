# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Mark do
  subject(:mark) { described_class.new(:mark, attributes: { 'style' => 'color: #ffbb11' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#styles' do
    subject(:styles) { mark.styles }

    it 'merges the callback property into styles' do
      expect(styles).to match(color: 'ffbb11', callback: PrawnHtml::Callbacks::Highlight)
    end
  end
end
