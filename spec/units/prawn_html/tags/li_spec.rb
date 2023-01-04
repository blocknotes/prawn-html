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
    let(:parent_i) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'i' }) }
    let(:parent_I) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'I' }) }
    let(:parent_a) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'a' }) }
    let(:parent_A) { PrawnHtml::Tags::Ol.new(:ol, attributes: { 'type' => 'A' }) }

    before do
      li.parent = parent
      li.on_context_add(context)
    end

    it 'sets the counter in before content' do
      expect(before_content).to eq('1. ')
    end

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

end
