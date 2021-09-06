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
      described_class.new(:a, attributes: { 'href' => 'https://www.google.it', 'style' => 'font-weight: bold' })
    end

    before do
      a.process_styles
    end

    it 'includes the link property in the styles' do
      expect(a.styles).to match(color: '0000ee', link: 'https://www.google.it', styles: [:underline, :bold])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<a href="https://www.google.it">A link</a>' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf', :aggregate_failures do
      expected_buffer = [{ size: TestUtils.default_font_size, text: 'A link', link: 'https://www.google.it', color: '0000ee', styles: [:underline] }]
      expected_options = { leading: TestUtils.adjust_leading }
      expected_extra = { bounding_box: nil, left_indent: 0 }

      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end
end
