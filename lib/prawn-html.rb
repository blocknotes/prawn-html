# frozen_string_literal: true

require 'prawn'

require 'prawn_html/tags/base'
Dir["#{__dir__}/prawn_html/tags/*.rb"].sort.each { |f| require f }

require 'prawn_html/attributes'
require 'prawn_html/context'
require 'prawn_html/document_renderer'
require 'prawn_html/html_handler'
