# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Span do
  it { expect(described_class).to be < PrawnHtml::Tag }

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<span>Some sample content</span>' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some sample content" }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end
end
