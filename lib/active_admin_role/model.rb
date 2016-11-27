module ActiveAdminRole
  module Model
    def role_based_authorizable
      send :include, ::ActiveAdminRole::RoleBasedAuthorizable
    end
  end
end
