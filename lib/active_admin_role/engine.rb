require "rails/engine"

module ActiveAdminRole
  class Engine < ::Rails::Engine
    initializer "active_admin_role" do
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :extend, ::ActiveAdminRole::Model
      end

      ActiveSupport.on_load :after_initialize do
        ::ActiveAdmin::ResourceController.send :include, ::ActiveAdminRole::ActiveAdmin::ResourceController
      end
    end
  end
end
