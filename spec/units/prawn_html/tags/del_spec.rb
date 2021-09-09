# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Del do
  subject(:del) { described_class.new(:del, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#styles' do
    subject(:styles) { del.styles }

    before do
      del.process_styles
    end

    it 'merges the callback property into styles' do
      expect(styles).to match(color: 'ffbb11', callback: ['StrikeThrough', nil])
    end
  end

  describe 'tag rendering' do
    include_context 'with pdf wrapper'

    before { append_html_to_pdf(html) }

    context 'with a Del tag' do
      let(:html) { '<del>Some sample content</del>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ callback: anything, size: TestUtils.default_font_size, text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end

    context 'with a S tag' do
      let(:html) { '<s>Some sample content</s>' }

      it 'sends the expected buffer elements to the pdf' do
        expect(pdf).to have_received(:puts).with(
          [{ callback: anything, size: TestUtils.default_font_size, text: "Some sample content" }],
          { leading: TestUtils.adjust_leading },
          { bounding_box: nil, left_indent: 0 }
        )
      end
    end
  end
end
