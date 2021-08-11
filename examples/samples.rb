# frozen_string_literal: true

$LOAD_PATH << '../lib'

require 'prawn'
require 'prawn-html'
require 'oga'
require 'pry'

Dir[File.expand_path('*.html', __dir__)].sort.each do |file|
  html = File.read(file)
  pdf = Prawn::Document.new(page_size: 'A4', page_layout: :portrait)
  PrawnHtml.append_html(pdf, html)
  out = file.gsub(/\.html\Z/, '.pdf')
  pdf.render_file(out)
end
