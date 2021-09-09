# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Body do
  subject(:body) { described_class.new(:body) }

  it { expect(described_class).to be < PrawnHtml::Tag }

  describe '#block?' do
    subject(:block?) { body.block? }

    it { is_expected.to be_truthy }
  end
end
