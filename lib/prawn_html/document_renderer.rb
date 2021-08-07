# frozen_string_literal: true

module PrawnHtml
  class DocumentRenderer
    # Init the DocumentRenderer
    #
    # @param pdf [Prawn::Document] target Prawn PDF document
    def initialize(pdf)
      @pdf = pdf
    end

    # On tag close callback
    #
    # @param element
    def on_tag_close(element)
      # TODO
    end

    # On tag open callback
    #
    # @param tag [String] the tag name of the opening element
    # @param attributes [Hash] an hash of the element attributes
    def on_tag_open(tag, attributes)
      # TODO
    end

    # On text node callback
    #
    # @param content [String] the text node content
    def on_text_node(content)
      # TODO
    end
  end
end
