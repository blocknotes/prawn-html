# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Img < Tag
      ELEMENTS = [:img].freeze

      def block?
        true
      end

      def custom_render(pdf, context)
        styles = Attributes.parse_styles(attrs.style)
        block_styles = context.block_styles
        evaluated_styles = evaluate_styles(pdf, block_styles.merge(styles))
        pdf.image(@attrs.src, evaluated_styles) if @attrs.src
      end

      private

      def evaluate_styles(pdf, styles)
        {}.tap do |result|
          result[:width] = Utils.convert_size(styles['width'], pdf.bounds.width) if styles.include?('width')
          result[:height] = Utils.convert_size(styles['height'], pdf.bounds.height) if styles.include?('height')
          result[:position] = styles[:align] if %i[left center right].include?(styles[:align])
        end
      end
    end
  end
end
