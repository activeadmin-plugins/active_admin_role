require "spec_helper"

describe ActiveAdmin::ManagedResource, type: :model do
  it { is_expected.to have_many(:permissions).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:class_name) }
  it { is_expected.to validate_presence_of(:action) }

  describe "#const" do
    subject { described_class.new(class_name: class_name).const }

    context "when class_name is existing" do
      let(:class_name) { "AdminUser" }
      it("should be constant") { is_expected.to be AdminUser }
    end

    context "when class_name is not existing" do
      let(:class_name) { "Foobar" }
      it { is_expected.to be_nil }
    end
  end

  describe "#active?" do
    subject { described_class.new(class_name: class_name).active? }

    context "when class_name is existing" do
      let(:class_name) { "AdminUser" }
      it { is_expected.to be true }
    end

    context "when class_name is not existing" do
      let(:class_name) { "Foobar" }
      it { is_expected.to be false }
    end
  end

  describe "#for_active_admin_page?" do
    subject { described_class.new(class_name: class_name).for_active_admin_page? }

    context "when class_name is ActiveAdmin::Page" do
      let(:class_name) { "ActiveAdmin::Page" }
      it { is_expected.to be true }
    end

    context "when class_name is not ActiveAdmin::Page" do
      let(:class_name) { "AdminUser" }
      it { is_expected.to be false }
    end
  end

  describe ".reload" do
    subject { described_class.reload }

    it { expect { subject }.not_to raise_error }
    it("should create ActiveAdmin::ManagedResource") { expect { subject }.to change { described_class.count } }
    it("should create ActiveAdmin::Permission") { expect { subject }.to change { ActiveAdmin::Permission.count } }
  end
end
