# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Div do
  subject(:div) { described_class.new(:div) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { div.block? }

    it { is_expected.to be_truthy }
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<div>Some sample content</div>' }

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
