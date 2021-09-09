# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Mark do
  subject(:mark) { described_class.new(:mark, attributes: { 'style' => 'color: #ffbb11' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#styles' do
    subject(:styles) { mark.styles }

    before do
      mark.process_styles
    end

    it 'merges the callback property into styles' do
      expect(styles).to match(color: 'ffbb11', callback: ['Background', 'ffff00'])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<mark>Some sample content</mark>' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ callback: anything, size: TestUtils.default_font_size, text: "Some sample content" }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end
end
