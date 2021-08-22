# frozen_string_literal: true

module PrawnHtml
  module Tags
    class Img < Tag
      ELEMENTS = [:img].freeze

      def block?
        true
      end

      def custom_render(pdf, context)
        parsed_styles = Attributes.parse_styles(attrs.style)
        block_styles = context.block_styles
        evaluated_styles = evaluate_styles(pdf, block_styles.merge(parsed_styles))
        pdf.image(@attrs.src, evaluated_styles) if @attrs.src
      end

      private

      def evaluate_styles(pdf, img_styles)
        {}.tap do |result|
          result[:width] = Utils.convert_size(img_styles['width'], pdf.bounds.width) if img_styles.include?('width')
          result[:height] = Utils.convert_size(img_styles['height'], pdf.bounds.height) if img_styles.include?('height')
          result[:position] = img_styles[:align] if %i[left center right].include?(img_styles[:align])
        end
      end
    end
  end
end
