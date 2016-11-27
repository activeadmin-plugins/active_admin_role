require "spec_helper"

describe "/admin/permissions", type: :feature do
  before do
    prepare_admin_users
    login_as :admin
    click_link "Permissions"
  end

  describe "reload" do
    before { click_link "Reload" }

    it "should be able to reload permissions" do
      expect(page).to have_css "table#index_table_permissions"
    end
  end

  describe "batch action", js: true do
    before do
      click_link "Reload"
      find(:css, "tr#active_admin_permission_35 td.col-selectable input").set("1")
      click_link "Batch Actions"
      click_link "Enable Selected"
      find("li.scope.staff a").click
    end

    it "should enable permission" do
      within "tr#active_admin_permission_35" do
        expect(page).to     have_css "td.col-state", text: "CAN"
        expect(page).not_to have_css "td.col-state", text: "CANNOT"
      end
    end
  end
end
