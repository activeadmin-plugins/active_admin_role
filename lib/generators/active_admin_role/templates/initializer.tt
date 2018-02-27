ActiveAdminRole.configure do |config|
  # [Required:Hash]
  # == Role | default: { guest: 0, support: 1, staff: 2, manager: 3, admin: 99 }
  config.roles = { guest: 0, support: 1, staff: 2, manager: 3, admin: 99 }

  # [Optional:Array]
  # == Special roles which don't need to manage on database
  config.super_user_roles = [:admin]
  config.guest_user_roles = [:guest]

  # [Optional:String]
  # == User class name | default: 'AdminUser'
  config.user_class_name = "<%= model_class_name %>"

  # [Optional:String]
  # == method name of #current_user in Controller
  config.current_user_method_name = "current_<%= model_class_name.underscore.tr('/', '_') %>"

  # [Optional:Symbol]
  # == Default permission | default: :cannot
  config.default_state = :cannot
end
