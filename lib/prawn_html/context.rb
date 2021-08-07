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

    # Merges the context options
    #
    # @return [Hash] the hash of merged options
    def merge_options
      each_with_object({}) do |element, res|
        element.options.each do |key, value|
          Attributes.merge_attr!(res, key, value)
        end
      end
    end

    # Merge the context styles
    #
    # @return [Hash] the hash of merged styles
    def merge_styles
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
      element.styles.each do |key, val|
        if res.include?(key) && res[key].is_a?(Array)
          res[key] += val
        else
          res[key] = val
        end
      end
    end
  end
end
