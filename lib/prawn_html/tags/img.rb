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
        evaluated_styles = adjust_styles(pdf, block_styles.merge(parsed_styles))
        pdf.image(@attrs.src, evaluated_styles)
      end

      private

      def adjust_styles(pdf, img_styles)
        {}.tap do |result|
          w, h = img_styles['width'], img_styles['height']
          result[:width] = Utils.convert_size(w, options: pdf.bounds.width) if w
          result[:height] = Utils.convert_size(h, options: pdf.bounds.height) if h
          result[:position] = img_styles[:align] if %i[left center right].include?(img_styles[:align])
        end
      end
    end
  end
end
