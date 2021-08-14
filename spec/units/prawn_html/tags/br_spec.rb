# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Br do
  subject(:br) { described_class.new(:br) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { br.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { br.custom_render(pdf, context) }

    let(:context) { instance_double(PrawnHtml::Context, last_text_node: false) }
    let(:pdf) { instance_double(Prawn::Document, move_down: true) }

    it 'calls move_down on the pdf instance' do
      custom_render
      expect(pdf).to have_received(:move_down)
    end

    context 'when the last node in the context is of type text' do
      let(:context) { instance_double(PrawnHtml::Context, last_text_node: true) }

      it "doesn't call move_down on the pdf instance" do
        custom_render
        expect(pdf).not_to have_received(:move_down)
      end
    end
  end
end
