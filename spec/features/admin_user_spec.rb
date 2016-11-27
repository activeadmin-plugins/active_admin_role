require "spec_helper"

describe "/admin/admin_users", type: :feature do
  before do
    prepare_admin_users
    login_as :admin
    click_link "Admin Users"
  end

  describe "scope" do
    it "should display scopes" do
      within "ul.scopes.table_tools_segmented_control" do
        expect(page).to have_link "All", href: admin_admin_users_path(scope: :all)

        AdminUser.roles.each_key do |role|
          expect(page).to have_link role, href: admin_admin_users_path(scope: role)
        end
      end
    end

    it "should return scoped collections" do
      AdminUser.roles.each_key do |role|
        find("li.scope.#{role} a").click

        within "#index_table_admin_users" do
          expect(page).to have_css "td.col-email", text: "#{role}@example.com"
        end
      end
    end
  end

  describe "batch action", js: true do
    before do
      find(:css, "tr#admin_user_1 td.col-selectable input").set("1")
      click_link "Batch Actions"
      click_link "assign as admin Selected"
      find("li.scope.admin a").click
    end

    it "should assign role to admin" do
      within "#index_table_admin_users" do
        expect(page).to have_css "td.col-email", text: "guest@example.com"
      end
    end
  end
end
