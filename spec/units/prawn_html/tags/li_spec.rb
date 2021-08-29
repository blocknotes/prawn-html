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
  end
end
