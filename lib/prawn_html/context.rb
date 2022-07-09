# frozen_string_literal: true

module PrawnHtml
  class Context < Array
    DEFAULT_STYLES = {
      size: 16 * PX
    }.freeze

    attr_reader :previous_tag
    attr_accessor :last_text_node, :current_table

    # Init the Context
    def initialize(*_args)
      super
      @current_table = nil
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
        each_with_object(DEFAULT_STYLES.dup) do |element, res|
          evaluate_element_styles(element, res)
          element.update_styles(res)
        end
    end

    # :nocov:
    def inspect
      map(&:class).map(&:to_s).join(', ')
    end
    # :nocov:

    # Remove the last element from the context
    def remove_last
      last.on_context_remove(self) if last.respond_to?(:on_context_remove)
      @merged_styles = nil
      @last_text_node = false
      @previous_tag = last
      pop
    end

    # White space is equal to 'pre'?
    #
    # @return [boolean] white space property of the last element is equal to 'pre'
    def white_space_pre?
      last && last.styles[:white_space] == :pre
    end

    private

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
