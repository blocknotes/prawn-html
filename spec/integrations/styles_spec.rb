# frozen_string_literal: true

RSpec.describe 'Styles' do
  let(:pdf) { Prawn::Document.new(page_size: 'A4', page_layout: :portrait) }

  before do
    PrawnHtml.append_html(pdf, html)
  end

  describe 'attribute text-align' do
    context 'with some content left aligned' do
      let(:html) { '<div style="text-align: left">Some content</div>' }

      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          pdf.page.margins[:left],
          (pdf.y - TestUtils.default_font.ascender).round(4)
        ]]
      end

      include_examples 'checks contents and positions'
    end

    context 'with some content center aligned' do
      let(:html) { '<div style="text-align: center">Some content</div>' }

      let(:content_width) { TestUtils.font_string_width(pdf, expected_content.first) }
      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          (pdf.page.margins[:left] + ((pdf.bounds.width - content_width) / 2)).round(4),
          (pdf.y - TestUtils.default_font.ascender).round(4)
        ]]
      end

      include_examples 'checks contents and positions'
    end

    context 'with some content right aligned' do
      let(:html) { '<div style="text-align: right">Some content</div>' }

      let(:content_width) { TestUtils.font_string_width(pdf, expected_content.first) }
      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        x = pdf.page.margins[:left] + pdf.bounds.width - content_width
        [[
          x.round(4),
          (pdf.y - TestUtils.default_font.ascender).round(4)
        ]]
      end

      include_examples 'checks contents and positions'
    end
  end

  describe 'attribute break-after' do
    let(:html) { '<div style="break-after: auto">Some content</div>' }

    it 'creates a new page' do
      pdf.render
      expect(pdf.page_count).to eq 2
    end
  end

  describe 'attribute break-before' do
    let(:html) { '<div style="break-before: auto">Some content</div>' }

    it 'creates a new page' do
      pdf.render
      expect(pdf.page_count).to eq 2
    end
  end

  describe 'attribute font-family' do
    context 'with some content with Courier font' do
      let(:html) { '<div style="font-family: Courier">Some content</div>' }
      let(:size) { TestUtils.default_font_size }

      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          pdf.page.margins[:left],
          (pdf.y - TestUtils.font_ascender(font_family: 'Courier', font_size: size)).round(4)
        ]]
      end
      let(:expected_font_settings) { [{ name: :Courier, size: size }] }

      include_examples 'checks contents, positions and font settings'
    end
  end

  describe 'attribute font-size' do
    context 'with some content with a font size of 20px' do
      let(:html) { '<div style="font-size: 20px">Some content</div>' }
      let(:size) { PrawnHtml::Utils.convert_size('20px') }

      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          pdf.page.margins[:left],
          (pdf.y - TestUtils.prawn_document.font('Helvetica', size: size).ascender).round(4)
        ]]
      end
      let(:expected_font_settings) { [{ name: TestUtils.default_font_family, size: size }] }

      include_examples 'checks contents, positions and font settings'
    end
  end

  describe 'attribute font-style' do
    context 'with some content with italic style' do
      let(:html) { '<div style="font-style: italic">Some content</div>' }
      let(:size) { TestUtils.default_font_size }

      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          pdf.page.margins[:left],
          (pdf.y - TestUtils.prawn_document.font('Helvetica-Oblique', size: size).ascender).round(4)
        ]]
      end
      let(:expected_font_settings) { [{ name: :'Helvetica-Oblique', size: size }] }

      include_examples 'checks contents, positions and font settings'
    end
  end

  describe 'attribute font-weight' do
    context 'with some content with bold weight' do
      let(:html) { '<div style="font-weight: bold">Some content</div>' }
      let(:size) { TestUtils.default_font_size }

      let(:expected_content) { ['Some content'] }
      let(:expected_positions) do
        [[
          pdf.page.margins[:left],
          (pdf.y - TestUtils.prawn_document.font('Helvetica-Bold', size: size).ascender).round(4)
        ]]
      end
      let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

      include_examples 'checks contents, positions and font settings'
    end
  end

  describe 'attribute letter-spacing' do
    let(:html) { '<div style="letter-spacing: 1.5">aaa</div> bbb <div style="letter-spacing: 2">ccc</div>' }

    it 'renders some content with letter spacing', :aggregate_failures do
      text_analysis = PDF::Inspector::Text.analyze(pdf.render)

      expect(text_analysis.strings).to eq(['aaa', 'bbb', 'ccc'])
      expect(text_analysis.character_spacing).to eq(([1.5, 0.0] * 3) + ([2.0, 0.0] * 3))
    end
  end

  describe 'attribute margin-left' do
    let(:html) { '<div style="margin-left: 40px">Some content</div>' }
    let(:size) { PrawnHtml::Utils.convert_size('40px') }

    let(:expected_content) { ['Some content'] }
    let(:expected_positions) do
      [[
        pdf.page.margins[:left] + size,
        (pdf.y - TestUtils.default_font.ascender).round(4)
      ]]
    end

    include_examples 'checks contents and positions'
  end

  describe 'attribute margin-top' do
    let(:html) { '<div style="margin-top: 40px">Some content</div>' }
    let(:size) { PrawnHtml::Utils.convert_size('40px') }

    let(:expected_content) { ['Some content'] }
    let(:expected_positions) do
      [[
        pdf.page.margins[:left],
        (pdf.y - TestUtils.default_font.ascender - size).round(4)
      ]]
    end

    include_examples 'checks contents and positions'
  end
end
