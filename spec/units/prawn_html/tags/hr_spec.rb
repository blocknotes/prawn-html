# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Hr do
  subject(:hr) { described_class.new(:hr, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected tag_styles for hr tag' do
      expect(hr.tag_styles).to eq(
        'margin-bottom' => PrawnHtml::Tags::Hr::MARGIN_BOTTOM.to_s,
        'margin-top' => PrawnHtml::Tags::Hr::MARGIN_TOP.to_s
      )
    end
  end

  describe '#block?' do
    subject(:block?) { hr.block? }

    it { is_expected.to be_truthy }
  end

  describe '#custom_render' do
    subject(:custom_render) { hr.custom_render(pdf, context) }

    let(:context) { nil }
    let(:pdf) { instance_double(Prawn::Document, stroke_horizontal_rule: true) }

    it 'calls stroke_horizontal_rule on the pdf instance' do
      custom_render
      expect(pdf).to have_received(:stroke_horizontal_rule)
    end

    context 'with a dash number set' do
      subject(:hr) { described_class.new(:hr, 'data-dash' => '5') }

      let(:pdf) { instance_double(Prawn::Document, dash: true, stroke_horizontal_rule: true, undash: true) }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:dash).with(5).ordered
        expect(pdf).to have_received(:stroke_horizontal_rule).ordered
        expect(pdf).to have_received(:undash).ordered
      end
    end

    context 'with a dash array set' do
      subject(:hr) { described_class.new(:hr, 'data-dash' => '1, 2, 3') }

      let(:pdf) { instance_double(Prawn::Document, dash: true, stroke_horizontal_rule: true, undash: true) }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:dash).with([1, 2, 3]).ordered
        expect(pdf).to have_received(:stroke_horizontal_rule).ordered
        expect(pdf).to have_received(:undash).ordered
      end
    end
  end
end
