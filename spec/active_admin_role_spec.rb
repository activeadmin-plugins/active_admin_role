require "spec_helper"

describe ActiveAdminRole do
  describe ".configure" do
    subject { described_class.configure {|config| config.default_state = :cannot } }
    it { expect { subject }.not_to raise_error }
  end

  describe ".config" do
    subject { described_class.config }
    it { is_expected.to be_a described_class::Config }
  end

  describe "version" do
    subject { described_class::VERSION }
    it { is_expected.not_to be_nil }
  end
end
