require "rails/engine"

module ActiveAdminRole
  class Engine < ::Rails::Engine
    initializer "active_admin_role" do
      ActiveSupport.on_load :active_record do
        require "active_admin_role/monkey/active_record_dsl"
        extend ActiveAdminRole::ActiveRecordDsl
      end

      ActiveSupport.on_load :after_initialize do
        require "active_admin_role/monkey/active_admin_dsl"
        require "active_admin_role/monkey/active_admin_controller"
        ActiveAdmin::DSL.send :include, ActiveAdminRole::ActiveAdminDsl
        ActiveAdmin::ResourceController.send :include, ActiveAdminRole::ActiveAdminController
      end
    end
  end
end
