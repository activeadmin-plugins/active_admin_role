require "spec_helper"

describe ActiveAdminRole::RoleBasedAuthorizable, type: :model do
  describe ".included" do
    subject { AdminUser.new }

    it { is_expected.to define_enum_for(:role).with(ActiveAdminRole.config.roles) }
    it { is_expected.to delegate_method(:super_user_roles).to(:class) }
    it { is_expected.to delegate_method(:guest_user_roles).to(:class) }
    it { is_expected.to validate_presence_of(:role) }
  end

  describe "#super_user?" do
    let(:model) { AdminUser.new(role: role) }
    subject { model.super_user? }

    context "when role is super user role" do
      let(:role) { :admin }
      it { is_expected.to be true }
    end

    context "when role is not super user role" do
      let(:role) { :guest }
      it { is_expected.to be false }
    end
  end

  describe "#guest_user?" do
    let(:model) { AdminUser.new(role: role) }
    subject { model.guest_user? }

    context "when role is guest user role" do
      let(:role) { :guest }
      it { is_expected.to be true }
    end

    context "when role is not guest user role" do
      let(:role) { :admin }
      it { is_expected.to be false }
    end
  end

  describe ".manageable_roles" do
    let(:result) do
      manageless_roles = (ActiveAdminRole.config.super_user_roles + ActiveAdminRole.config.guest_user_roles).flatten.compact.map(&:to_s)
      ActiveAdminRole.config.roles.stringify_keys.except(*manageless_roles)
    end

    subject { AdminUser.manageable_roles }
    it { is_expected.to eq result }
  end

  describe ".super_user_roles" do
    subject { AdminUser.super_user_roles }
    it { is_expected.to be_a Array }
  end

  describe ".guest_user_roles" do
    subject { AdminUser.guest_user_roles }
    it { is_expected.to be_a Array }
  end
end
