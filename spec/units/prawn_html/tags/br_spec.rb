# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Br do
  subject(:br) { described_class.new(:br) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { br.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { br.custom_render(pdf, context) }

    let(:context) { instance_double(PrawnHtml::Context, last_text_node: false, previous_tag: nil) }
    let(:pdf) { instance_double(PrawnHtml::PdfWrapper, advance_cursor: true) }

    it "doesn't call advance_cursor on the pdf wrapper" do
      custom_render
      expect(pdf).not_to have_received(:advance_cursor)
    end

    context 'when the last node in the context is another br' do
      let(:context) { instance_double(PrawnHtml::Context, last_text_node: false, previous_tag: :br) }

      it 'calls advance_cursor on the pdf wrapper' do
        custom_render
        expect(pdf).to have_received(:advance_cursor)
      end
    end

    context 'when the last node in the context is of type text' do
      let(:context) { instance_double(PrawnHtml::Context, last_text_node: true) }

      it "doesn't call advance_cursor on the pdf wrapper" do
        custom_render
        expect(pdf).not_to have_received(:advance_cursor)
      end
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { 'First line<br>Second line<br/>Third line<br><br>Last line' }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf', :aggregate_failures do
      expected_options = { leading: TestUtils.adjust_leading }
      expected_extra = { bounding_box: nil, left_indent: 0 }

      expected_text = { text: "First line", size: TestUtils.default_font_size }
      expect(pdf).to have_received(:puts).with([expected_text], expected_options, expected_extra).ordered

      expected_text = { text: "Second line", size: TestUtils.default_font_size }
      expect(pdf).to have_received(:puts).with([expected_text], expected_options, expected_extra).ordered

      expected_text = { text: "Third line", size: TestUtils.default_font_size }
      expect(pdf).to have_received(:puts).with([expected_text], expected_options, expected_extra).ordered

      expect(pdf).to have_received(:advance_cursor).with(described_class::BR_SPACING).ordered

      expected_text = { text: "Last line", size: TestUtils.default_font_size }
      expect(pdf).to have_received(:puts).with([expected_text], expected_options, expected_extra).ordered
    end
  end
end
