# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::A do
  subject(:a) { described_class.new(:a, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      a.process_styles
    end

    it "styles doesn't include the link property" do
      expect(a.styles).to eq(color: 'ffbb11')
    end
  end

  context 'with an href attribute' do
    subject(:a) do
      described_class.new(:a, attributes: { 'href' => 'https://www.google.it', 'style' => 'color: #fb1' })
    end

    before do
      a.process_styles
    end

    it 'includes the link property in the styles' do
      expect(a.styles).to match(color: 'ffbb11', link: 'https://www.google.it')
    end
  end
end
