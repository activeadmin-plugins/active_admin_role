module ActiveAdminRole
  module ActiveRecordDsl
    def role_based_authorizable
      include ::ActiveAdminRole::RoleBasedAuthorizable
    end
  end
end
