# frozen_string_literal: true

require 'oga'

module PrawnHtml
  class HtmlParser
    REGEXP_STYLES = /\s*([^{\s]+)\s*{\s*([^}]*?)\s*}/m.freeze

    # Init the HtmlParser
    #
    # @param renderer [DocumentRenderer] document renderer
    def initialize(renderer)
      @processing = false
      @renderer = renderer
      @styles = {}
    end

    # Processes HTML and renders it
    #
    # @param html [String] The HTML content to process
    def process(html)
      @processing = !html.include?('<body')
      @document = Oga.parse_html(html)
      traverse_nodes(document.children)
      renderer.flush
    end

    private

    attr_reader :document, :processing, :renderer, :styles

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
      renderer.on_tag_open(tag, attributes: attributes, element_styles: styles[node])
    end

    def init_element(node)
      node.name.downcase.to_sym.tap do |tag_name|
        @processing = true if tag_name == :body
        process_styles(node.text) if tag_name == :style
      end
    end

    def process_styles(styles_string)
      styles_hash = styles_string.scan(REGEXP_STYLES).to_h
      styles_hash.each do |selector, rule|
        document.css(selector).each do |node|
          styles[node] = rule
        end
      end
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
