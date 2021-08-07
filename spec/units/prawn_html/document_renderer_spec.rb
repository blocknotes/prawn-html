# frozen_string_literal: true

RSpec.describe PrawnHtml::DocumentRenderer do
  describe '#assign_document_styles' do
    it 'assignes the document styles', skip: 'TODO' do
      # ...
    end
  end

  describe '#on_tag_close' do
    it 'handles tag closing', skip: 'TODO' do
      # ...
    end
  end

  describe '#on_tag_open' do
    it 'handles tag opening', skip: 'TODO' do
      # ...
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
