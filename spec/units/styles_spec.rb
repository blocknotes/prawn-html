# frozen_string_literal: true

RSpec.describe 'Styles' do
  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, advance_cursor: true, puts: true) }

  before do
    allow(pdf).to receive_messages(page_width: 540, page_height: 720)
    allow(PrawnHtml::PdfWrapper).to receive(:new).and_return(pdf)
    pdf_document = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
    PrawnHtml.append_html(pdf_document, html)
  end

  describe 'attribute color' do
    let(:html) { '<div style="color: #fb1">Some content...</div>' }

    let(:expected_buffer) { [{ color: 'ffbb11', size: TestUtils.default_font_size, text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute font-family' do
    let(:html) { '<div style="font-family: Courier">Some content...</div>' }

    let(:expected_buffer) { [{ font: 'Courier', size: TestUtils.default_font_size, text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute font-size' do
    let(:html) { '<div style="font-size: 20px">Some content...</div>' }
    let(:size) { PrawnHtml::Utils.convert_size('20px') }

    let(:expected_buffer) { [{ size: size, text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading(20 * PrawnHtml::PX) } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute font-style' do
    let(:html) { '<div style="font-style: italic">Some content...</div>' }

    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:italic], text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute font-weight' do
    let(:html) { '<div style="font-weight: bold">Some content...</div>' }

    let(:expected_buffer) { [{ size: TestUtils.default_font_size, styles: [:bold], text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute letter-spacing' do
    let(:html) { '<div style="letter-spacing: 1.5">aaa</div> bbb <div style="letter-spacing: 2">ccc</div>' }
    let(:size) { TestUtils.default_font_size }

    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

    it 'sends the expected buffer elements to Prawn pdf', :aggregate_failures do
      expect(pdf).to have_received(:puts).with(
        [{ character_spacing: 1.5, size: size, text: 'aaa' }], expected_options, expected_extra
      )
      expect(pdf).to have_received(:puts).with([{ size: size, text: ' bbb ' }], expected_options, expected_extra)
      expect(pdf).to have_received(:puts).with(
        [{ character_spacing: 2.0, size: size, text: 'ccc' }], expected_options, expected_extra
      )
    end
  end

  describe 'attribute line-height' do
    let(:html) { '<div style="line-height: 12">Some content...</div>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some content..." }],
        { leading: (12 * PrawnHtml::PX).round(5) },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end

  describe 'attribute margin-left' do
    let(:html) { '<div style="margin-left: 40px">Some content...</div>' }

    let(:expected_buffer) { [{ size: TestUtils.default_font_size, text: "Some content..." }] }
    let(:expected_options) { { leading: TestUtils.adjust_leading } }
    let(:expected_extra) { { bounding_box: nil, left_indent: 40 * PrawnHtml::PX } }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
    end
  end

  describe 'attribute margin-top' do
    let(:html) { '<div style="margin-top: 40">Some content...</div>' }

    it 'sends the expected buffer elements to Prawn pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: TestUtils.default_font_size, text: "Some content..." }],
        { leading: TestUtils.adjust_leading },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end

  describe 'attribute text-align' do
    context 'with some content left aligned' do
      let(:html) { '<div style="text-align: left">Some content...</div>' }

      let(:expected_buffer) { [{ size: TestUtils.default_font_size, text: "Some content..." }] }
      let(:expected_options) { { align: :left, leading: TestUtils.adjust_leading } }
      let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end

    context 'with some content center aligned' do
      let(:html) { '<div style="text-align: center">Some content...</div>' }

      let(:expected_buffer) { [{ size: TestUtils.default_font_size, text: "Some content..." }] }
      let(:expected_options) { { align: :center, leading: TestUtils.adjust_leading } }
      let(:expected_extra) { { bounding_box: nil, left_indent: 0 } }

      it 'sends the expected buffer elements to Prawn pdf' do
        expect(pdf).to have_received(:puts).with(expected_buffer, expected_options, expected_extra)
      end
    end
  end
end
