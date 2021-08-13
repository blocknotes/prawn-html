# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Img do
  subject(:img) { described_class.new(:img) }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  describe '#block?' do
    subject(:block?) { img.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { img.custom_render(pdf, context) }

    let(:context) { instance_double(PrawnHtml::Context, merge_options: {}) }
    let(:pdf) { instance_double(Prawn::Document, image: true) }

    it 'calls image on the pdf instance' do
      custom_render
      expect(pdf).to have_received(:image)
    end
  end
end
