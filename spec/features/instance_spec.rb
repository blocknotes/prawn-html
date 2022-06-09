# frozen_string_literal: true

RSpec.describe 'Instance' do
  it 'preserves the styles in the instance' do
    pdf = Prawn::Document.new(page_size: 'A4')
    phtml = PrawnHtml::Instance.new(pdf)
    phtml.append(html: '<style>h1 { color: green }</style>')
    phtml.append(html: '<h1>Some HTML before</h1>')
    pdf.text 'Some Prawn text'
    phtml.append(html: '<h1>Some HTML after</h1>')

    output_file = File.expand_path('../../examples/instance.pdf', __dir__)
    pdf.render_file(output_file) unless File.exist?(output_file)

    expected_pdf = File.read(output_file)
    expect(Zlib.crc32(pdf.render)).to eq Zlib.crc32(expected_pdf)
  end
end
