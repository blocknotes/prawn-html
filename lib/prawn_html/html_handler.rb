# frozen_string_literal: true

require 'oga'

module PrawnHtml
  class HtmlHandler
    # Init the HtmlHandler
    #
    # @param pdf [Prawn::Document] Target Prawn PDF document
    def initialize(pdf)
      @pdf = pdf
      @processing = false
    end

    # Processes HTML and renders it on the PDF document
    #
    # @param html [String] The HTML content to process
    def process(html)
      doc = Oga.parse_html(html)
      traverse_nodes(doc.children)
    end

    private

    def traverse_nodes(nodes)
      nodes.each do |node|
        element = node_open(node)
        traverse_nodes(node.children) if node.children.any?
        node_close(element) if element
      end
    end

    def node_open(node)
      node.is_a?(Oga::XML::Element) && init_element(node)
    end

    def init_element(node)
      node.name.downcase.to_sym
    end

    def node_close(element)
      # TODO
    end
  end
end
