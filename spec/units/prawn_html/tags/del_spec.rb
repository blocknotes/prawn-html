# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Del do
  subject(:del) { described_class.new(:del, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#styles' do
    subject(:styles) { del.styles }

    before do
      del.process_styles
    end

    it 'merges the callback property into styles' do
      expect(styles).to match(color: 'ffbb11', callback: 'StrikeThrough')
    end
  end
end
