require "spec_helper"

describe ActiveAdminRole::ManageableResource do
  let(:model) { described_class.new }

  describe "#call" do
    subject { model.call }
    it { is_expected.to be_a Array }
    it { is_expected.to all be_a Hash }
  end
end
