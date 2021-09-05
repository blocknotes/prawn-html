# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::B do
  subject(:b) { described_class.new(:b, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      b.process_styles
    end

    it 'returns the expected styles for b tag' do
      expect(b.styles).to match(color: 'ffbb11', styles: [:bold])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    before { append_html_to_pdf(html) }

    context 'with a B tag' do
      let(:html) { '<b>Some sample content</b>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:bold], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end

    context 'with a Strong tag' do
      let(:html) { '<strong>Some sample content</strong>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:bold], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end
  end
end
