# frozen_string_literal: true

require 'oga'

module PrawnHtml
  class HtmlHandler
    # Init the HtmlHandler
    #
    # @param pdf [Prawn::Document] Target Prawn PDF document
    def initialize(pdf)
      @processing = false
      @renderer = DocumentRenderer.new(pdf)
    end

    # Processes HTML and renders it on the PDF document
    #
    # @param html [String] The HTML content to process
    def process(html)
      doc = Oga.parse_html(html)
      traverse_nodes(doc.children)
    end

    private

    attr_reader :renderer

    def traverse_nodes(nodes)
      nodes.each do |node|
        element = node_open(node)
        traverse_nodes(node.children) if node.children.any?
        node_close(element) if element
      end
    end

    def node_open(node)
      tag = node.is_a?(Oga::XML::Element) && init_element(node)
      return renderer.on_text_node(node.text) unless tag

      attributes = prepare_attributes(node)
      renderer.on_tag_open(tag, attributes)
    end

    def init_element(node)
      node.name.downcase.to_sym    end

    def prepare_attributes(node)
      node.attributes.each_with_object({}) do |attr, res|
        res[attr.name] = attr.value
      end
    end

    def node_close(element)
      renderer.on_tag_close(element)
    end
  end
end
