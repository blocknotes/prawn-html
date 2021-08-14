# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Hr do
  subject(:hr) { described_class.new(:hr, 'style' => 'color: ffbb11') }

  it { expect(described_class).to be < PrawnHtml::Tag }

  context 'without attributes' do
    it 'returns the expected extra_attrs for hr tag' do
      expect(hr.extra_attrs).to eq(
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
  end
end
