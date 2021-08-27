# frozen_string_literal: true

RSpec.describe PrawnHtml::PdfWrapper do
  subject(:pdf_wrapper) { described_class.new(pdf) }

  let(:pdf) { instance_double(Prawn::Document) }

  describe 'delegated methods' do
    %i[bounds start_new_page].each do |method_name|
      context "with #{method_name} method" do
        before do
          allow(pdf).to receive(method_name)
        end

        it 'delegates the method call to the pdf instance' do
          pdf_wrapper.send(method_name)
          expect(pdf).to have_received(method_name)
        end
      end
    end
  end

  describe '#advance_cursor' do
    subject(:advance_cursor) { pdf_wrapper.advance_cursor(quantity) }

    before do
      allow(pdf).to receive(:move_down)
    end

    context 'with some quantity' do
      let(:quantity) { 20 }

      it 'delegates to PDF move_down' do
        advance_cursor
        expect(pdf).to have_received(:move_down).with(20)
      end
    end

    context 'with zero quantity' do
      let(:quantity) { 0 }

      it "doesn't move down" do
        advance_cursor
        expect(pdf).not_to have_received(:move_down).with(20)
      end
    end
  end

  describe '#draw_rectangle' do
    subject(:draw_rectangle) { pdf_wrapper.draw_rectangle(x: 50, y: 80, width: 200, height: 150, color: 'ffbb111') }

    before do
      allow(pdf).to receive_messages(fill_color: 'aabbbcc', :fill_color= => true, fill_rectangle: true)
    end

    it 'calls the PDF fill_rectangle method', :aggregate_failures do
      draw_rectangle
      expect(pdf).to have_received(:fill_color=).with('ffbb111').ordered
      expect(pdf).to have_received(:fill_rectangle).with([80, 50], 200, 150).ordered
      expect(pdf).to have_received(:fill_color=).with('aabbbcc').ordered
    end
  end

  describe '#horizontal_rule' do
    subject(:horizontal_rule) { pdf_wrapper.horizontal_rule(color: color, dash: dash) }

    let(:color) { 'ffbb11' }
    let(:dash) { 5 }

    before do
      methods = { dash: nil, stroke_color: 'abcdef', :stroke_color= => nil, stroke_horizontal_rule: nil, undash: nil }
      allow(pdf).to receive_messages(methods)
    end

    it 'calls the PDF stroke_horizontal_rule method', :aggregate_failures do
      horizontal_rule
      expect(pdf).to have_received(:stroke_color).ordered
      expect(pdf).to have_received(:dash).with(5).ordered
      expect(pdf).to have_received(:stroke_color=).with('ffbb11').ordered
      expect(pdf).to have_received(:stroke_horizontal_rule).ordered
      expect(pdf).to have_received(:stroke_color=).with('abcdef').ordered
      expect(pdf).to have_received(:undash).ordered
    end
  end

  describe '#image' do
    subject(:image) { pdf_wrapper.image(src, options) }

    let(:src) { 'some_image_path' }
    let(:options) { {} }

    before do
      allow(pdf).to receive(:image)
    end

    it 'calls the PDF image method' do
      image
      expect(pdf).to have_received(:image).with(src, options)
    end
  end

  describe '#puts' do
    subject(:puts) { pdf_wrapper.puts(buffer, options, bounding_box: bounding_box) }

    let(:bounding_box) { nil }
    let(:buffer) { [] }
    let(:options) { {} }

    before do
      allow(pdf).to receive(:formatted_text)
    end

    it 'calls the PDF formatted_text method' do
      puts
      expect(pdf).to have_received(:formatted_text).with(buffer, options)
    end
  end

  describe '#underline' do
    subject(:underline) { pdf_wrapper.underline(x1: x1, x2: x2, y: y) }

    let(:x1) { 20 }
    let(:x2) { 50 }
    let(:y) { 40 }

    before do
      allow(pdf).to receive(:stroke).and_yield
      allow(pdf).to receive(:line)
    end

    it 'calls the PDF formatted_text method', :aggregate_failures do
      underline
      expect(pdf).to have_received(:stroke).ordered
      expect(pdf).to have_received(:line).with([20, 40], [50, 40]).ordered
    end
  end
end
