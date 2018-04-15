require "rails/engine"
require "active_admin_role/active_admin/dsl"

module ActiveAdminRole
  class Engine < ::Rails::Engine
    initializer "active_admin_role" do
      ActiveSupport.on_load :active_record do
        extend ActiveAdminRole::Dsl
      end

      ActiveSupport.on_load :after_initialize do
        require "active_admin_role/active_admin/resource_controller"
        ::ActiveAdmin::ResourceController.send :include, ActiveAdminRole::ActiveAdmin::ResourceController
      end
    end
  end
end
