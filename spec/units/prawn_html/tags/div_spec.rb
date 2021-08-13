# frozen_string_literal: true

RSpec.describe PrawnHtml::Tags::Div do
  subject(:div) { described_class.new(:div) }

  it { expect(described_class).to be < PrawnHtml::Tags::Base }

  describe '#block?' do
    subject(:block?) { div.block? }

    it { is_expected.to be_truthy }
  end
end
