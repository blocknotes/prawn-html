# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Li do
  subject(:li) { described_class.new(:li, attributes: { 'style' => 'color: #fb1' }) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { li.block? }

    it { is_expected.to be_truthy }
  end

  describe '#before_content' do
    subject(:before_content) { li.before_content }

    let(:context) { instance_double(PrawnHtml::Context) }
    let(:parent) { PrawnHtml::Tags::Ul.new(:ul) }

    before do
      li.parent = parent
      li.on_context_add(context)
    end

    it 'merges the before_content property into before_content' do
      expect(before_content).to eq('&bullet; ')
    end
  end

  describe 'when the parent is an ol element' do
    subject(:before_content) { li.before_content }

    let(:context) { instance_double(PrawnHtml::Context) }
    let(:parent) { PrawnHtml::Tags::Ol.new(:ol) }

    before do
      li.parent = parent
      li.on_context_add(context)
    end

    it 'sets the counter in before content' do
      expect(before_content).to eq('1. ')
    end

    let(:parent_i) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'i' }) }
    let(:parent_I) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'I' }) }
    let(:parent_a) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'a' }) }
    let(:parent_A) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'A' }) }

    it 'sets the counter in before content with type i' do      
      li.parent = parent_i
      expect(before_content).to eq('i. ')
    end

    it 'sets the counter in before content with type I' do
      li.parent = parent_I
      expect(before_content).to eq('I. ')
    end

    it 'sets the counter in before content with type a' do
      li.parent = parent_a
      expect(before_content).to eq('a. ')
    end

    it 'sets the counter in before content with type A' do
      li.parent = parent_A
      expect(before_content).to eq('A. ')
    end

  end

  describe 'before_content for different types' do
    subject(:before_content) { li.before_content }

    let(:context) { instance_double(PrawnHtml::Context) }
    let(:parent) { PrawnHtml::Tags::Ol.new(:ol) }

    before do
      li.parent = parent
      li.on_context_add(context)
    end

    it 'sets the counter for type i' do
      expect(li.counter_display(1, 'i')).to eq('i')
      expect(li.counter_display(2, 'i')).to eq('ii')
      expect(li.counter_display(3, 'i')).to eq('iii')
      expect(li.counter_display(4, 'i')).to eq('iv')
      expect(li.counter_display(5, 'i')).to eq('v')
      expect(li.counter_display(6, 'i')).to eq('vi')
      expect(li.counter_display(7, 'i')).to eq('vii')
      expect(li.counter_display(8, 'i')).to eq('viii')
      expect(li.counter_display(9, 'i')).to eq('ix')
      expect(li.counter_display(10, 'i')).to eq('x')
    end
    it 'sets the counter for type I' do
      expect(li.counter_display(1, 'I')).to eq('I')
      expect(li.counter_display(2, 'I')).to eq('II')
      expect(li.counter_display(3, 'I')).to eq('III')
      expect(li.counter_display(4, 'I')).to eq('IV')
      expect(li.counter_display(5, 'I')).to eq('V')
      expect(li.counter_display(6, 'I')).to eq('VI')
      expect(li.counter_display(7, 'I')).to eq('VII')
      expect(li.counter_display(8, 'I')).to eq('VIII')
      expect(li.counter_display(9, 'I')).to eq('IX')
      expect(li.counter_display(10, 'I')).to eq('X')
    end
    it 'sets the counter for type A' do
      expect(li.counter_display(1, 'A')).to eq('A')
      expect(li.counter_display(2, 'A')).to eq('B')
      expect(li.counter_display(3, 'A')).to eq('C')
      expect(li.counter_display(4, 'A')).to eq('D')
      expect(li.counter_display(5, 'A')).to eq('E')
      expect(li.counter_display(6, 'A')).to eq('F')
      expect(li.counter_display(7, 'A')).to eq('G')
      expect(li.counter_display(8, 'A')).to eq('H')
      expect(li.counter_display(9, 'A')).to eq('I')
      expect(li.counter_display(10, 'A')).to eq('J')
    end
    it 'sets the counter for type a' do
      expect(li.counter_display(1, 'a')).to eq('a')
      expect(li.counter_display(2, 'a')).to eq('b')
      expect(li.counter_display(3, 'a')).to eq('c')
      expect(li.counter_display(4, 'a')).to eq('d')
      expect(li.counter_display(5, 'a')).to eq('e')
      expect(li.counter_display(6, 'a')).to eq('f')
      expect(li.counter_display(7, 'a')).to eq('g')
      expect(li.counter_display(8, 'a')).to eq('h')
      expect(li.counter_display(9, 'a')).to eq('i')
      expect(li.counter_display(10, 'a')).to eq('j')
    end
    it 'sets the counter for type 1' do
      expect(li.counter_display(1)).to eq('1')
      expect(li.counter_display(2)).to eq('2')
      expect(li.counter_display(3)).to eq('3')
      expect(li.counter_display(4)).to eq('4')
      expect(li.counter_display(5)).to eq('5')
      expect(li.counter_display(6)).to eq('6')
      expect(li.counter_display(7)).to eq('7')
      expect(li.counter_display(8)).to eq('8')
      expect(li.counter_display(9)).to eq('9')
      expect(li.counter_display(10)).to eq('10')
    end

  end
end
