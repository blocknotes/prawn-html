# frozen_string_literal: true

RSpec.describe 'Misc' do
  let(:pdf_doc) { TestUtils.styled_text_document(html) }

  shared_examples 'a specific element with some test content' do
    let(:html) { [expected_content[0], test_content, expected_content[2]].join }

    let(:expected_content) { ['Some', 'test', 'content'] }
    let(:expected_positions) do
      x1 = pdf_doc.page.margins[:left]
      x2 = x1 + TestUtils.font_string_width(pdf_doc, expected_content.first)
      x3 = x2 + TestUtils.font_string_width(pdf_doc, test_content, inline_format: true)
      y = pdf_doc.y - TestUtils.default_font.ascender
      [[x1.round(4), y.round(4)], [x2.round(4), y.round(4)], [x3.round(4), y.round(4)]]
    end
    let(:expected_font_settings) do
      [
        { name: :Helvetica, size: TestUtils.default_font_size },
        { name: expected_font_family.to_sym, size: TestUtils.default_font_size },
        { name: :Helvetica, size: TestUtils.default_font_size }
      ]
    end

    include_examples 'checks contents, positions and font settings'
  end

  context 'with some content in an element b' do
    it_behaves_like 'a specific element with some test content' do
      let(:test_content) { '<b>test</b>' }
      let(:expected_font_family) { 'Helvetica-Bold' }
    end
  end

  context 'with some content in an element em' do
    it_behaves_like 'a specific element with some test content' do
      let(:test_content) { '<em>test</em>' }
      let(:expected_font_family) { 'Helvetica-Oblique' }
    end
  end

  context 'with some content in an element i' do
    it_behaves_like 'a specific element with some test content' do
      let(:test_content) { '<i>test</i>' }
      let(:expected_font_family) { 'Helvetica-Oblique' }
    end
  end

  context 'with some content in an element strong' do
    it_behaves_like 'a specific element with some test content' do
      let(:test_content) { '<strong>test</strong>' }
      let(:expected_font_family) { 'Helvetica-Bold' }
    end
  end

  it 'renders some breaking line elements' do
    html = 'First line<br>Second line<br/>Third line'
    pdf = TestUtils.styled_text_document(html)
    text_analysis = PDF::Inspector::Text.analyze(pdf.render)

    expect(text_analysis.strings).to match_array(['First line', 'Second line', 'Third line'])
  end
end
