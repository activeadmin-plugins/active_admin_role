require "active_admin"
require "active_admin_role/active_admin/dsl"
require "active_admin_role/active_admin/resource_controller"
require "active_admin_role/can_can/ability"
require "active_admin_role/config"
require "active_admin_role/engine"
require "active_admin_role/manageable_resource"
require "active_admin_role/model"
require "active_admin_role/role_based_authorizable"

module ActiveAdminRole
  def self.configure
    yield(config)
  end

  def self.config
    @_config ||= Config.new
  end
end

::ActiveAdmin::DSL.send :include, ActiveAdminRole::ActiveAdmin::DSL
