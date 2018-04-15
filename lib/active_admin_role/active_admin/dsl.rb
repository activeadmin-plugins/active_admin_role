module ActiveAdminRole
  module ActiveAdmin
    module Dsl
      def role_changeable
        scope(:all, default: true)

        controller.resource_class.roles.each_key(&method(:scope))
        controller.resource_class.roles.each_key do |role|
          batch_action "assign as #{role}" do |ids|
            formatted_ids = ids - [active_admin_role_current_user.try!(:id).to_s]
            resource_class.where(id: formatted_ids).update_all(role: resource_class.roles[role])

            if Rails::VERSION::MAJOR >= 5
              redirect_back fallback_location: admin_root_url, notice: t("views.admin_user.notice.assigned", role: role)
            else
              redirect_to :back, notice: t("views.admin_user.notice.assigned", role: role)
            end
          end
        end
      end
    end
  end
end

::ActiveAdmin::DSL.send :include, ActiveAdminRole::ActiveAdmin::Dsl if defined?(::ActiveAdmin)
