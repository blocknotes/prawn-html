# frozen_string_literal: true

RSpec.shared_examples 'checks contents and positions' do
  it 'matches the expected contents and positions', :aggregate_failures do
    text_analysis = PDF::Inspector::Text.analyze(pdf_doc.render)
    positions = text_analysis.positions.map { |item| [item[0].round(4), item[1].round(4)] }
    expect(text_analysis.strings).to eq expected_content
    expect(positions).to eq expected_positions
  end
end

RSpec.shared_examples 'checks contents, positions and font settings' do
  it 'matches the expected contents, positions and font settings', :aggregate_failures do
    text_analysis = PDF::Inspector::Text.analyze(pdf_doc.render)
    positions = text_analysis.positions.map { |item| [item[0].round(4), item[1].round(4)] }
    expect(text_analysis.strings).to eq expected_content
    expect(text_analysis.font_settings).to eq expected_font_settings
    expect(positions).to eq expected_positions
  end
end
