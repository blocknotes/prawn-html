# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::I do
  subject(:i) { described_class.new(:i, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    before do
      i.process_styles
    end

    it 'returns the expected styles for i tag' do
      expect(i.styles).to match(color: 'ffbb11', styles: [:italic])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    before { append_html_to_pdf(html) }

    context 'with an I tag' do
      let(:html) { '<i>Some sample content</i>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:italic], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end

    context 'with an Em tag' do
      let(:html) { '<em>Some sample content</em>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ size: TestUtils.default_font_size, styles: [:italic], text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end
  end
end
