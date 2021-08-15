# frozen_string_literal: true

module PrawnHtml
  class Context < Array
    DEF_FONT_SIZE = 10.3

    attr_accessor :last_margin, :last_text_node

    # Init the Context
    def initialize(*_args)
      super
      @last_margin = 0
    end

    def before_content
      return '' if empty? || !last.respond_to?(:tag_styles)

      last.tag_styles[:before_content].to_s
    end

    # Merges the context block styles
    #
    # @return [Hash] the hash of merged styles
    def block_styles
      each_with_object({}) do |element, res|
        element.block_styles.each do |key, value|
          Attributes.merge_attr!(res, key, value)
        end
      end
    end

    # Merge the context styles for text nodes
    #
    # @return [Hash] the hash of merged styles
    def text_node_styles
      context_styles = each_with_object({}) do |element, res|
        evaluate_element_styles(element, res)
        element.update_styles(res) if element.respond_to?(:update_styles)
      end
      base_styles.merge(context_styles)
    end

    private

    def base_styles
      {
        size: DEF_FONT_SIZE
      }
    end

    def evaluate_element_styles(element, res)
      styles = element.styles.slice(*Attributes::STYLES_APPLY[:text_node])
      styles.each do |key, val|
        if res.include?(key) && res[key].is_a?(Array)
          res[key] += val
        else
          res[key] = val
        end
      end
    end
  end
end
