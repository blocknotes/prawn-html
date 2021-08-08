# frozen_string_literal: true

RSpec.describe PrawnHtml::DocumentRenderer do
  subject(:document_renderer) { described_class.new(pdf_doc) }

  let(:context) { PrawnHtml::Context.new }
  let(:pdf_doc) { instance_double(Prawn::Document, formatted_text: nil) }

  before do
    allow(PrawnHtml::Context).to receive(:new).and_return(context)
  end

  describe '#assign_document_styles' do
    let(:styles) do
      {
        'body' => 'font-family: Courier',
        '.a_class' => 'color: #08f; font-size: 10px',
        '#an_id' => 'font-weight: bold'
      }
    end

    before do
      allow(PrawnHtml::Attributes).to receive(:new).and_call_original
    end

    it 'assigns the document styles' do
      expected_styles = {
        'body' => { font: 'Courier' },
        '.a_class' => { color: '0088ff', size: (10 * PrawnHtml::PX).round(4) },
        '#an_id' => { styles: [:bold] }
      }

      expect(document_renderer.assign_document_styles(styles)).to eq(expected_styles)
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
    subject(:on_text_node) { document_renderer.on_text_node(content) }

    let(:content) { 'some content' }

    before do
      allow(Oga::HTML::Entities).to receive(:decode).and_call_original
    end

    it { is_expected.to be_nil }

    it 'calls the decode method for before content' do
      on_text_node
      expect(Oga::HTML::Entities).to have_received(:decode)
    end

    context 'with blank content' do
      let(:content) { " \n " }

      it "doesn't call the decode method" do
        on_text_node
        expect(Oga::HTML::Entities).not_to have_received(:decode)
      end
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