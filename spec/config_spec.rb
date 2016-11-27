require "spec_helper"

describe ActiveAdminRole::Config do
  describe "#default_state=" do
    let(:instance) { described_class.new }

    before { instance.default_state = value }

    subject { instance.default_state }

    context "when value is :can" do
      let(:value) { :can }
      it { is_expected.to be :can }
    end

    context "when value is :cannot" do
      let(:value) { :cannot }
      it { is_expected.to be :cannot }
    end

    context "when value is others" do
      let(:value) { 123 }
      it { is_expected.to be :cannot }
    end
  end
end
