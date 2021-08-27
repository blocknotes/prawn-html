# frozen_string_literal: true

RSpec.describe 'Headings' do
  let(:pdf) { Prawn::Document.new(page_size: 'A4', page_layout: :portrait) }

  before do
    PrawnHtml.append_html(pdf, html)
  end

  def base_position(pdf, font_size, margin_top: 16)
    font = Prawn::Document.new(page_size: 'A4', page_layout: :portrait).font('Helvetica-Bold', size: font_size)
    [pdf.page.margins[:left], pdf.y - font.ascender - margin_top]
  end

  context 'with some content in an element h1' do
    let(:html) { '<h1>Some content in a element h1</h1>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h1].to_s) }
    let(:expected_content) { ['Some content in a element h1'] }
    let(:expected_positions) do
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h1].to_s)
      y = pdf.y - TestUtils.font_ascender(font_size: size) - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element h2' do
    let(:html) { '<h2>Some content in a element h2</h2>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h2].to_s) }
    let(:expected_content) { ['Some content in a element h2'] }
    let(:expected_positions) do
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h2].to_s)
      y = pdf.y - TestUtils.font_ascender(font_size: size) - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element h3' do
    let(:html) { '<h3>Some content in a element h3</h3>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h3].to_s) }
    let(:expected_content) { ['Some content in a element h3'] }
    let(:expected_positions) do
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h3].to_s)
      y = pdf.y - TestUtils.font_ascender(font_size: size) - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element h4' do
    let(:html) { '<h4>Some content in a element h4</h4>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h4].to_s) }
    let(:expected_content) { ['Some content in a element h4'] }
    let(:expected_positions) do
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h4].to_s)
      y = pdf.y - TestUtils.font_ascender(font_size: size) - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element h5' do
    let(:html) { '<h5>Some content in a element h5</h5>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h5].to_s) }
    let(:expected_content) { ['Some content in a element h5'] }
    let(:expected_positions) do
      ascender = TestUtils.font_ascender(font_family: 'Helvetica-Bold', font_size: size)
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h5].to_s)
      y = pdf.y - ascender - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element h6' do
    let(:html) { '<h6>Some content in a element h6</h6>' }

    let(:size) { PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::SIZES[:h6].to_s) }
    let(:expected_content) { ['Some content in a element h6'] }
    let(:expected_positions) do
      ascender = TestUtils.font_ascender(font_family: 'Helvetica-Bold', font_size: size)
      margin = PrawnHtml::Utils.convert_size(PrawnHtml::Tags::H::MARGINS_TOP[:h6].to_s)
      y = pdf.y - ascender - margin
      [[pdf.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: :'Helvetica-Bold', size: size }] }

    include_examples 'checks contents, positions and font settings'
  end
end
