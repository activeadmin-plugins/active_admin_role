require "spec_helper"

describe ActiveAdminRole::Model do
  describe ".role_based_authorizable" do
    let(:klass) { Class.new { extend ::ActiveAdminRole::Model } }

    it "should include ::ActiveAdminRole::RoleBasedAuthorizable" do
      expect(klass).to receive(:include).once
      klass.role_based_authorizable
    end
  end
end
