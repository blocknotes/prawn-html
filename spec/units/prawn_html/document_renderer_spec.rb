# frozen_string_literal: true

RSpec.describe PrawnHtml::DocumentRenderer do
  subject(:document_renderer) { described_class.new(pdf_doc) }

  let(:context) { PrawnHtml::Context.new }
  let(:pdf_doc) { instance_double(Prawn::Document, formatted_text: nil) }

  before do
    allow(PrawnHtml::Context).to receive(:new).and_return(context)
  end

  describe '#assign_document_styles' do
    it 'assignes the document styles', skip: 'TODO' do
      # ...
    end
  end

  describe '#on_tag_close' do
    subject(:on_tag_close) { document_renderer.on_tag_close(element) }

    let(:element) { PrawnHtml::Tags::Div.new(:div) }

    before do
      allow(element).to receive(:post_styles).and_call_original
    end

    it 'handles tag closing' do
      on_tag_close
      expect(element).to have_received(:post_styles)
    end
  end

  describe '#on_tag_open' do
    subject(:on_tag_open) { document_renderer.on_tag_open(tag, attributes) }

    let(:tag) { :div }
    let(:attributes) { { 'class' => 'green' } }

    it { is_expected.to be_kind_of PrawnHtml::Tags::Div }

    context 'with an unknown tag' do
      let(:tag) { :unknown_tag }

      it { is_expected.to be_nil }
    end
  end

  describe '#on_text_node' do
    it 'handles text nodes', skip: 'TODO' do
      # ...
    end
  end

  describe '#render' do
    subject(:render) { document_renderer.render }

    before do
      allow(context).to receive(:merge_styles).and_call_original
    end

    it "renders nothing when the buffer's content is empty" do
      render
      expect(context).not_to have_received(:merge_styles)
    end

    context 'with some content in the buffer' do
      before do
        document_renderer.on_text_node('Some content')
      end

      it "renders the current buffer's content" do
        render
        expect(context).to have_received(:merge_styles)
      end
    end
  end

  describe 'alias method: flush' do
    it { is_expected.to respond_to(:flush) }
  end
end
