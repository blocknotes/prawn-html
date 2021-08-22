# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Del do
  subject(:del) { described_class.new(:del, 'style' => 'color: #ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#styles' do
    subject(:styles) { del.styles }

    it 'merges the callback property into styles' do
      expect(styles).to match(color: 'ffbb11', callback: PrawnHtml::Callbacks::StrikeThrough)
    end
  end
end
