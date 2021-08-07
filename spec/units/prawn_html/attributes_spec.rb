# frozen_string_literal: true

RSpec.describe PrawnHtml::Attributes do
  subject(:attributes) { described_class.new(attributes_hash) }

  let(:attributes_hash) { { attr1: 'value 1', attr2: 'value 2' } }

  describe '#initialize' do
    before do
      allow(OpenStruct).to receive(:new).and_call_original
    end

    it 'stores the attributes hash in an open struct' do
      attributes
      expect(OpenStruct).to have_received(:new).with(attributes_hash)
    end
  end
end
