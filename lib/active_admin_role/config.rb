module ActiveAdminRole
  class Config
    attr_accessor :roles, :super_user_roles, :guest_user_roles, :user_class_name, :current_user_method_name
    attr_reader :default_state

    def initialize
      @roles            = { guest: 0, support: 1, staff: 2, manager: 3, admin: 99 }
      @guest_user_roles = [:guest]
      @super_user_roles = [:admin]
      @user_class_name  = "AdminUser"
      @default_state    = :cannot
      @current_user_method_name = "current_admin_user"
    end

    def default_state=(value)
      @default_state = (value.to_s == "can") ? :can : :cannot
    end
  end
end
