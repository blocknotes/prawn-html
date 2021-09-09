# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::U do
  subject(:u) { described_class.new(:u, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      u.process_styles
    end

    it 'returns the expected styles for u tag' do
      expect(u.styles).to match(color: 'ffbb11', styles: [:underline])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    before { append_html_to_pdf(html) }

    context 'with a U tag' do
      let(:html) { '<u>Some sample content</u>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:underline], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end

    context 'with a Ins tag' do
      let(:html) { '<ins>Some sample content</ins>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:underline], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end
  end
end
