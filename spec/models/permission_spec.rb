require "spec_helper"

describe ActiveAdmin::Permission, type: :model do
  describe "association" do
    it { is_expected.to belong_to(:managed_resource) }
  end

  describe "delegation" do
    it { is_expected.to delegate_method(:class_name).to(:managed_resource) }
    it { is_expected.to delegate_method(:action).to(:managed_resource) }
    it { is_expected.to delegate_method(:name).to(:managed_resource) }
    it { is_expected.to delegate_method(:const).to(:managed_resource) }
    it { is_expected.to delegate_method(:active?).to(:managed_resource) }
    it { is_expected.to delegate_method(:for_active_admin_page?).to(:managed_resource) }
    it { is_expected.to delegate_method(:clear_cache).to(:class) }
  end

  describe "validation" do
    before { described_class.create(managed_resource_id: 1) }

    it { is_expected.to validate_presence_of(:managed_resource_id) }
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_presence_of(:state) }
    it { is_expected.to validate_uniqueness_of(:managed_resource_id).scoped_to(:role) }
  end

  describe "enum" do
    it { is_expected.to define_enum_for(:state).with(cannot: 0, can: 1) }
    it { is_expected.to define_enum_for(:role).with(ActiveAdminRole.config.roles) }
  end

  describe "callback" do
    let!(:model) { described_class.create(managed_resource_id: 1) }

    it "should run callback #clear_cache after update" do
      expect(model).to receive(:clear_cache).once
      model.can!
    end
  end

  describe "#to_condition" do
    let(:model) { described_class.create(managed_resource: managed_resource) }
    subject { model.to_condition }

    context "when managed_resource is for_active_admin_page" do
      let(:managed_resource) do
        ActiveAdmin::ManagedResource.create(
          class_name: "ActiveAdmin::Page",
          name: "Dashboard",
          action: "read",
        )
      end
      let(:result) { [model.state, model.action.to_sym, model.const, { name: model.name }] }

      it { is_expected.to eq result }
    end

    context "when managed_resource is not for_active_admin_page" do
      let(:managed_resource) do
        ActiveAdmin::ManagedResource.create(
          class_name: "ActiveAdmin::Permission",
          name: "Permission",
          action: "read",
        )
      end
      let(:result) { [model.state, model.action.to_sym, model.const] }

      it { is_expected.to eq result }
    end
  end

  describe "ClassMethods" do
    let(:managed_resources) do
      %i(read create update destroy).map do |action|
        ActiveAdmin::ManagedResource.create(
          class_name: "ActiveAdmin::Permission",
          name: "Permission",
          action: action,
        )
      end
    end

    describe ".update_all_from_managed_resources" do
      subject { described_class.update_all_from_managed_resources(managed_resources) }
      it { expect { subject }.to change { described_class.count }.to(12).from(0) }
    end

    describe ".indexed_cache" do
      before { described_class.update_all_from_managed_resources(managed_resources) }
      subject { described_class.indexed_cache }
      it { is_expected.to be_a Hash }
    end

    describe ".clear_cache" do
      before do
        described_class.update_all_from_managed_resources(managed_resources)
        described_class.indexed_cache
      end

      subject { described_class.clear_cache }

      it "should clear cache" do
        expect(described_class.instance_variable_get(:@_indexed_cache)).to be_a Hash
        subject
        expect(described_class.instance_variable_get(:@_indexed_cache)).to be_nil
      end
    end
  end
end
