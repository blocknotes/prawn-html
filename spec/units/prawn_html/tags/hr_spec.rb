# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Hr do
  subject(:hr) { described_class.new(:hr, 'style' => 'color: ffbb11') }

  let(:pdf) { instance_double(PrawnHtml::PdfWrapper, horizontal_rule: true) }

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

    it 'calls horizontal_rule on the pdf wrapper' do
      custom_render
      expect(pdf).to have_received(:horizontal_rule).with(color: nil, dash: nil)
    end

    context 'with a dash number set' do
      subject(:hr) { described_class.new(:hr, 'data-dash' => '5') }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: nil, dash: 5)
      end
    end

    context 'with a dash array set' do
      subject(:hr) { described_class.new(:hr, 'data-dash' => '1, 2, 3') }

      it 'calls the dash methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: nil, dash: [1, 2, 3])
      end
    end

    context 'with a color set via style attributes' do
      subject(:hr) { described_class.new(:hr, 'style' => 'color: red') }

      it 'calls the color methods around stroke', :aggregate_failures do
        custom_render
        expect(pdf).to have_received(:horizontal_rule).with(color: 'ff0000', dash: nil)
      end
    end
  end
end
