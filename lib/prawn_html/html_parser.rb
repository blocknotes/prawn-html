# frozen_string_literal: true

require 'oga'

module PrawnHtml
  class HtmlParser
    # Init the HtmlParser
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
      @processing = !html.include?('<body')
      doc = Oga.parse_html(html)
      traverse_nodes(doc.children)
      renderer.flush
    end

    private

    attr_reader :processing, :renderer

    def traverse_nodes(nodes)
      nodes.each do |node|
        element = node_open(node)
        traverse_nodes(node.children) if node.children.any?
        node_close(element) if element
      end
    end

    def node_open(node)
      tag = node.is_a?(Oga::XML::Element) && init_element(node)
      return unless processing
      return renderer.on_text_node(node.text) unless tag

      attributes = prepare_attributes(node)
      renderer.on_tag_open(tag, attributes)
    end

    def init_element(node)
      node.name.downcase.to_sym.tap do |tag_name|
        @processing = true if tag_name == :body
        renderer.assign_document_styles(extract_styles(node.text)) if tag_name == :style
      end
    end

    def extract_styles(text)
      text.scan(/\s*([^{\s]+)\s*{\s*([^}]*?)\s*}/m).to_h
    end

    def prepare_attributes(node)
      node.attributes.each_with_object({}) do |attr, res|
        res[attr.name] = attr.value
      end
    end

    def node_close(element)
      renderer.on_tag_close(element) if @processing
      @processing = false if element.tag == :body
    end
  end

  HtmlHandler = HtmlParser
end
