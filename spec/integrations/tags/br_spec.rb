# frozen_string_literal: true

RSpec.describe 'Misc' do
  let(:pdf) { Prawn::Document.new(page_size: 'A4', page_layout: :portrait) }
  let(:text_analysis) { PDF::Inspector::Text.analyze(pdf.render) }

  before do
    PrawnHtml.append_html(pdf, html)
  end

  context 'with some br elements' do
    let(:html) { 'First line<br>Second line<br/>Third line<br><br>Last line' }

    it 'renders some breaking line elements' do
      expected_strings = ['First line', 'Second line', 'Third line', 'Last line']
      expect(text_analysis.strings).to match_array(expected_strings)
    end
  end
end
