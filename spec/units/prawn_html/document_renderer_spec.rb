# frozen_string_literal: true

RSpec.describe PrawnHtml::DocumentRenderer do
  subject(:document_renderer) { described_class.new(pdf) }

  let(:context) { PrawnHtml::Context.new }
  let(:pdf) { PrawnHtml::PdfWrapper.new(pdf_doc) }
  let(:pdf_doc) { Prawn::Document.new }

  before do
    allow(PrawnHtml::Context).to receive(:new).and_return(context)
  end

  describe '#on_tag_close' do
    subject(:on_tag_close) { document_renderer.on_tag_close(element) }

    let(:element) { PrawnHtml::Tags::Div.new(:div) }

    before do
      allow(context).to receive(:remove_last)
      allow(element).to receive(:tag_closing).and_call_original
    end

    it 'handles tag closing', :aggregate_failures do
      on_tag_close
      expect(element).to have_received(:tag_closing)
      expect(context).to have_received(:remove_last)
    end
  end

  describe '#on_tag_open' do
    subject(:on_tag_open) do
      document_renderer.on_tag_open(tag, attributes: attributes, element_styles: element_styles)
    end

    let(:attributes) { { 'class' => 'green' } }
    let(:element_styles) { 'color: red' }

    context 'with a div tag' do
      let(:tag) { :div }

      before do
        allow(context).to receive(:add)
      end

      it { is_expected.to be_kind_of PrawnHtml::Tags::Div }

      it 'adds the element to the context' do
        on_tag_open
        expect(context).to have_received(:add)
      end
    end

    context 'with an unknown tag' do
      let(:tag) { :unknown_tag }

      it { is_expected.to be_nil }
    end
  end

  describe '#on_text_node' do
    subject(:on_text_node) { document_renderer.on_text_node(content) }

    let(:content) { 'some content' }

    it { is_expected.to be_nil }
  end

  describe '#render' do
    subject(:render) { document_renderer.render }

    before do
      allow(pdf).to receive_messages(puts: true)
    end

    it "renders nothing when the buffer's content is empty" do
      render
      expect(pdf).not_to have_received(:puts)
    end

    context 'with some content in the buffer' do
      before do
        document_renderer.on_text_node('Some content')
      end

      it "renders the current buffer's content" do
        render
        expect(pdf).to have_received(:puts)
      end
    end

    context 'with position absolute, top and left properties' do
      before do
        document_renderer.on_tag_open(:div, attributes: { 'style' => 'position: absolute; top: 10px; left: 50px' })
        document_renderer.on_text_node('Some content')
      end

      it "renders the current buffer's content in a bounded box" do
        render
        expect(pdf).to have_received(:puts)
      end
    end

    context 'with position absolute, bottom and right properties' do
      before do
        document_renderer.on_tag_open(:div, attributes: { 'style' => 'position: absolute; bottom: 10px; right: 80px' })
        document_renderer.on_text_node('Some content')
      end

      it "renders the current buffer's content in a bounded box" do
        render
        expect(pdf).to have_received(:puts)
      end
    end
  end

  describe 'alias method: flush' do
    it { is_expected.to respond_to(:flush) }
  end
end
