# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Ul do
  subject(:ul) { described_class.new(:ul, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { ul.block? }

    it { is_expected.to be_truthy }
  end

  context 'without attributes' do
    before do
      ul.process_styles
    end

    it 'returns the expected styles for ul tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_left: PrawnHtml::Utils.convert_size(described_class::MARGIN_LEFT.to_s),
      }
      expect(ul.styles).to match(expected_styles)
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) do
      <<~HTML
        <ul>
          <li>First item</li>
          <li>Second item</li>
          <li>Third item</li>
        </ul>
      HTML
    end
    let(:size) { TestUtils.default_font_size }
    let(:margin_left) do
      PrawnHtml::Utils.convert_size(PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
    end

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf', :aggregate_failures do
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• First item" }],
        { indent_paragraphs: PrawnHtml::Tags::Li::INDENT_UL, leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: margin_left }
      )
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• Second item" }],
        { indent_paragraphs: PrawnHtml::Tags::Li::INDENT_UL, leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: margin_left }
      )
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "• Third item" }],
        { indent_paragraphs: PrawnHtml::Tags::Li::INDENT_UL, leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: margin_left }
      )
    end
  end
end
