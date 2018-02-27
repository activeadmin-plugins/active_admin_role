require "spec_helper"

describe "integration test", type: :feature do
  def prepare_permissions
    ActiveAdmin::ManagedResource.reload
    ActiveAdmin::Permission.support.joins(:managed_resource).merge(
      ActiveAdmin::ManagedResource.where(class_name: "AdminUser"),
    ).all.map(&:can!)
    ActiveAdmin::Permission.staff.joins(:managed_resource).merge(
      ActiveAdmin::ManagedResource.where(class_name: "ActiveAdmin::Permission", action: "read"),
    ).all.map(&:can!)
    ActiveAdmin::Permission.manager.joins(:managed_resource).merge(
      ActiveAdmin::ManagedResource.where(class_name: "ActiveAdmin::Permission"),
    ).all.map(&:can!)
  end

  before do
    prepare_admin_users
    prepare_permissions
  end

  describe "guest" do
    before { login_as :guest }
    after  { logout }

    specify "guest can only visit Dashboard" do
      expect(page).to     have_css "ul.header-item#tabs li#dashboard"
      expect(page).not_to have_css "ul.header-item#tabs li#admin_users"
      expect(page).not_to have_css "ul.header-item#tabs li#permissions"

      visit admin_admin_users_path
      expect(page).to have_content "You are not authorized to perform this action."

      visit admin_permissions_path
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  describe "support" do
    before { login_as :support }
    after  { logout }

    specify "support can visit Dashboard and Admin Users" do
      expect(page).to     have_css "ul.header-item#tabs li#dashboard"
      expect(page).to     have_css "ul.header-item#tabs li#admin_users"
      expect(page).not_to have_css "ul.header-item#tabs li#permissions"

      visit admin_admin_users_path
      expect(page).not_to have_content "You are not authorized to perform this action."

      visit admin_permissions_path
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  describe "staff" do
    before { login_as :staff }
    after  { logout }

    specify "staff cannot execute disallowed action" do
      click_link "Permissions"
      click_link "Reload"
      expect(page).to have_content "You are not authorized to perform this action."
    end
  end

  describe "manager" do
    before { login_as :manager }
    after  { logout }

    specify "manager can execute allowed action (without CRUD)" do
      click_link "Permissions"
      click_link "Reload"
      expect(page).not_to have_content "You are not authorized to perform this action."
    end
  end
end
