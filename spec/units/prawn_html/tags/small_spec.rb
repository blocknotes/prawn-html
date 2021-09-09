# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Small do
  subject(:small) { described_class.new(:small, attributes: { 'style' => 'color: ffbb11' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#update_styles' do
    subject(:update_styles) { small.update_styles(styles) }

    let(:styles) { { some_attr: 'some_value' } }

    it 'updates the argument styles reducing the default font size' do
      expect(update_styles).to eq(some_attr: 'some_value', size: 8.16)
    end

    context 'with a parent font size' do
      let(:styles) { { some_attr: 'some_value', size: 20 } }

      it 'updates the argument styles reducing the current font size' do
        expect(update_styles).to eq(some_attr: 'some_value', size: 17.0)
      end
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    let(:html) { '<small>Some sample content</small>' }
    let(:size) { PrawnHtml::Context::DEF_FONT_SIZE * 0.85 }

    before { append_html_to_pdf(html) }

    it 'sends the expected buffer elements to the pdf' do
      expect(pdf).to have_received(:puts).with(
        [{ size: size, text: "Some sample content" }],
        { leading: TestUtils.adjust_leading(size) },
        { bounding_box: nil, left_indent: 0 }
      )
    end
  end
end
