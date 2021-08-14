# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Img < Tag
      ELEMENTS = [:img].freeze

      def block?
        true
      end

      def custom_render(pdf, context)
        styles = Attributes.parse_styles(attrs.hash.style)
        context_options = context.merge_options
        options = evaluate_styles(pdf, context_options.merge(styles))
        pdf.image(@attrs.hash.src, options)
      end

      private

      def evaluate_styles(pdf, styles)
        options = {}
        options[:width] = Attributes.convert_size(styles['width'], pdf.bounds.width) if styles.include?('width')
        options[:height] = Attributes.convert_size(styles['height'], pdf.bounds.height) if styles.include?('height')
        options[:position] = styles[:align] if %i[left center right].include?(styles[:align])
        options
      end
    end
  end
end
