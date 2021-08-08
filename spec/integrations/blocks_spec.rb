# frozen_string_literal: true

RSpec.describe 'Blocks' do
  let(:pdf_doc) { TestUtils.styled_text_document(html) }
  let(:size) { PrawnHtml::Context::DEF_FONT_SIZE }

  context 'with some content in an element div' do
    let(:html) { '<div>Some content in a element div</div>' }

    let(:expected_content) { ['Some content in a element div'] }
    let(:expected_positions) do
      [[
        pdf_doc.page.margins[:left],
        (pdf_doc.y - TestUtils.default_font.ascender).round(4)
      ]]
    end
    let(:expected_font_settings) { [{ name: TestUtils.default_font_family, size: size }] }

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element p' do
    let(:html) { '<p>Some content in a element p</p>' }

    let(:expected_content) { ['Some content in a element p'] }
    let(:expected_positions) do
      margin = PrawnHtml::Attributes.convert_size(PrawnHtml::Tags::P::MARGIN_TOP.to_s)
      y = pdf_doc.y - TestUtils.default_font.ascender - margin
      [[pdf_doc.page.margins[:left], y.round(4)]]
    end
    let(:expected_font_settings) { [{ name: TestUtils.default_font_family, size: size }] }

    include_examples 'checks contents, positions and font settings'
  end
end