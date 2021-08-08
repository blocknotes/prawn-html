# frozen_string_literal: true

RSpec.describe 'Lists' do
  context 'with an empty ul list' do
    it 'renders no strings', :aggregate_failures do
      html = <<~HTML
        <ul>
        </ul>
      HTML

      pdf = TestUtils.styled_text_document(html)
      text_analysis = PDF::Inspector::Text.analyze(pdf.render)

      expect(text_analysis.strings).to be_empty
      expect(text_analysis.font_settings).to be_empty
      expect(text_analysis.positions).to be_empty
    end
  end

  context 'with an ul list' do
    it 'renders the list of elements', :aggregate_failures do # rubocop:disable RSpec/ExampleLength
      html = <<~HTML
        <ul>
          <li>First item</li>
          <li>Second item</li>
          <li>Third item</li>
        </ul>
      HTML

      pdf = TestUtils.styled_text_document(html)
      text_analysis = PDF::Inspector::Text.analyze(pdf.render)

      expected_array = [{ name: TestUtils.default_font_family, size: TestUtils.default_font_size }] * 3

      expect(text_analysis.strings).to match_array(['•  First item', '•  Second item', '•  Third item'])
      expect(text_analysis.font_settings).to match_array(expected_array)

      font = TestUtils.default_font
      margin_left = PrawnHtml::Attributes.convert_size(PrawnHtml::Tags::Ul::MARGIN_LEFT.to_s)
      x = pdf.page.margins[:left] + margin_left
      y = pdf.y - font.ascender

      expected_array = [
        [x, y.round(4)],
        [x, (y - font.height).round(4)],
        [x, (y - font.height * 2).round(4)]
      ]

      expect(text_analysis.positions).to match_array(expected_array)
    end
  end
end
