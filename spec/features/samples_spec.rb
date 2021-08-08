# frozen_string_literal: true

RSpec.describe 'Samples' do
  Dir[File.expand_path('../../examples/*.html', __dir__)].sort.each do |file|
    it "renders the expected output for #{File.basename(file)}", :aggregate_failures do
      html = File.read(file)
      pdf = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
      PrawnHtml::HtmlHandler.new(pdf).process(html)
      expected_pdf = File.read(file.gsub(/\.html\Z/, '.pdf'))
      expect(Zlib.crc32(pdf.render)).to eq Zlib.crc32(expected_pdf)
    end
  end
end
