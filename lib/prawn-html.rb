# frozen_string_literal: true

require 'prawn'

require 'prawn_html/tags/base'
Dir["#{__dir__}/prawn_html/tags/*.rb"].sort.each { |f| require f }

Dir["#{__dir__}/prawn_html/callbacks/*.rb"].sort.each { |f| require f }

require 'prawn_html/attributes'
require 'prawn_html/context'
require 'prawn_html/document_renderer'
require 'prawn_html/html_handler'

module PrawnHtml
  PX = 0.66 # conversion constant for pixel sixes

  def append_html(pdf, html)
    handler = PrawnHtml::HtmlHandler.new(pdf)
    handler.process(html)
  end

  module_function :append_html
end
