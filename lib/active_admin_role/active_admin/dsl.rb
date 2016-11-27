module ActiveAdminRole
  module ActiveAdmin
    module DSL
      def role_changeable
        scope(:all, default: true)

        controller.resource_class.roles.each_key(&method(:scope))

        controller.resource_class.roles.each_key do |role|
          batch_action "assign as #{role}" do |ids|
            formatted_ids = ids - [current_admin_user.id.to_s]
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
