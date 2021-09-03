# frozen_string_literal: true

module PrawnHtml
  class Context < Array
    DEF_FONT_SIZE = 9.66

    attr_reader :previous_tag
    attr_accessor :last_text_node

    # Init the Context
    def initialize(*_args)
      super
      @last_text_node = false
      @merged_styles = nil
      @previous_tag = nil
    end

    # Add an element to the context
    #
    # Set the parent for the previous element in the chain.
    # Run `on_context_add` callback method on the added element.
    #
    # @param element [Tag] the element to add
    #
    # @return [Context] the context updated
    def add(element)
      element.parent = last
      push(element)
      element.on_context_add(self) if element.respond_to?(:on_context_add)
      @merged_styles = nil
      self
    end

    # Evaluate before content
    #
    # @return [String] before content string
    def before_content
      (last.respond_to?(:before_content) && last.before_content) || ''
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
    def merged_styles
      @merged_styles ||=
        each_with_object(base_styles) do |element, res|
          evaluate_element_styles(element, res)
          element.update_styles(res) if element.respond_to?(:update_styles)
        end
    end

    # Remove the last element from the context
    def remove_last
      @merged_styles = nil
      @last_text_node = false
      @previous_tag = last.tag
      pop
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
