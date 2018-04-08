module ActiveAdminRole
  module Dsl
    def role_based_authorizable
      include ::ActiveAdminRole::RoleBasedAuthorizable
    end
  end
end
