# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Img do
  subject(:img) { described_class.new(:img, src: 'some_image_url') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { img.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { img.custom_render(pdf, context) }

    let(:context) { instance_double(PrawnHtml::Context, block_styles: {}) }
    let(:pdf) { instance_double(Prawn::Document, image: true) }

    it 'calls image on the pdf instance', :aggregate_failures do
      custom_render
      expect(context).to have_received(:block_styles)
      expect(pdf).to have_received(:image).with('some_image_url', {})
    end
  end
end
