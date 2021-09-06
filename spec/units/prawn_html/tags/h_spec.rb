# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::H do
  subject(:h1) { described_class.new(:h1, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { h1.block? }

    it { is_expected.to be_truthy }
  end

  context 'without attributes' do
    before do
      h1.process_styles
    end

    it 'returns the expected styles for h1 tag' do
      expected_styles = {
        color: 'ffbb11',
        margin_bottom: PrawnHtml::Utils.convert_size(described_class::MARGINS_BOTTOM[:h1].to_s),
        margin_top: PrawnHtml::Utils.convert_size(described_class::MARGINS_TOP[:h1].to_s),
        size: PrawnHtml::Utils.convert_size(described_class::SIZES[:h1].to_s),
        styles: [:bold]
      }
      expect(h1.styles).to match(expected_styles)
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:expected_buffer) { [{ size: size, styles: [:bold], text: 'Some sample content' }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading(size) } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    before { append_html_to_pdf(html) }

    context 'with some content in an element h1' do
      let(:html) { '<h1>Some sample content</h1>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h1].to_s) }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content in an element h2' do
      let(:html) { '<h2>Some sample content</h2>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h2].to_s) }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content in an element h3' do
      let(:html) { '<h3>Some sample content</h3>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h3].to_s) }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content in an element h4' do
      let(:html) { '<h4>Some sample content</h4>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h4].to_s) }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content in an element h5' do
      let(:html) { '<h5>Some sample content</h5>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h5].to_s) }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content in an element h6' do
      let(:html) { '<h6>Some sample content</h6>' }
      let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h6].to_s) }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end
  end
end
