# frozen_string_literal: true

require 'oga'

module PrawnHtml
  class HtmlParser
    REGEXP_STYLES = /\s*([^{\s]+)\s*{\s*([^}]*?)\s*}/m.freeze

    # Init the HtmlParser
    #
    # @param renderer [DocumentRenderer] document renderer
    # @param ignore_content_tags [Array] array of tags (symbols) to skip their contents while preparing the PDF document
    def initialize(renderer, ignore_content_tags: %i[script style])
      @processing = false
      @ignore = false
      @ignore_content_tags = ignore_content_tags
      @renderer = renderer
      @raw_styles = {}
    end

    # Processes HTML and renders it
    #
    # @param html [String] The HTML content to process
    def process(html)
      @styles = {}
      @processing = !html.include?('<body')
      @document = Oga.parse_html(html)
      process_styles # apply previously loaded styles
      traverse_nodes(document.children)
      renderer.flush
    end

    # Parses CSS styles
    #
    # @param text_styles [String] The CSS styles to evaluate
    def parse_styles(text_styles)
      @raw_styles = text_styles.scan(REGEXP_STYLES).to_h
    end

    private

    attr_reader :document, :ignore, :processing, :renderer, :styles

    def traverse_nodes(nodes)
      nodes.each do |node|
        next if node.is_a?(Oga::XML::Comment)

        element = node_open(node)
        traverse_nodes(node.children) if node.children.any?
        node_close(element) if element
      end
    end

    def node_open(node)
      tag = node.is_a?(Oga::XML::Element) && init_element(node)
      return unless processing
      return IgnoredTag.new(tag) if ignore
      return renderer.on_text_node(node.text) unless tag

      renderer.on_tag_open(tag, attributes: prepare_attributes(node), element_styles: styles[node])
    end

    def init_element(node)
      node.name.downcase.to_sym.tap do |tag_name|
        @processing = true if tag_name == :body
        @ignore = true if @processing && @ignore_content_tags.include?(tag_name)
        process_styles(node.text) if tag_name == :style
      end
    end

    def process_styles(text_styles = nil)
      parse_styles(text_styles) if text_styles
      @raw_styles.each do |selector, rule|
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
      if processing
        renderer.on_tag_close(element) unless ignore
        @ignore = false if ignore && @ignore_content_tags.include?(element.tag)
      end
      @processing = false if element.tag == :body
    end
  end

  class IgnoredTag
    attr_accessor :tag

    def initialize(tag_name)
      @tag = tag_name
    end
  end

  HtmlHandler = HtmlParser
end
