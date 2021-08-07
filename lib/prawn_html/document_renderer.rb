# frozen_string_literal: true

module PrawnHtml
  class DocumentRenderer
    # Init the DocumentRenderer
    #
    # @param pdf [Prawn::Document] target Prawn PDF document
    def initialize(pdf)
      @context = Context.new
      @doc_styles = {}
      @pdf = pdf
    end

    # Assigns the document styles
    #
    # @param styles [Hash] styles hash with CSS selectors as keys and rules as values
    def assign_document_styles(styles)
      @doc_styles = styles.transform_values do |style_rules|
        Attributes.new(style: style_rules).styles
      end
    end

    # On tag close callback
    #
    # @param element
    def on_tag_close(element)
      context.pop
    end

    # On tag open callback
    #
    # @param tag [String] the tag name of the opening element
    # @param attributes [Hash] an hash of the element attributes
    def on_tag_open(tag, attributes)
      context.push(tag)
    end

    # On text node callback
    #
    # @param content [String] the text node content
    def on_text_node(content)
      # TODO
    end

    private

    attr_reader :context
  end
end
