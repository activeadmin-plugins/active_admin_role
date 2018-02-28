module ActiveAdminRole
  module RoleBasedAuthorizable
    def self.included(klass)
      klass.class_eval do
        extend ClassMethods

        enum role: config.roles
        delegate :super_user_roles, :guest_user_roles, to: :class
        validates :role, presence: true
      end
    end

    def super_user?
      role.in?(super_user_roles)
    end

    def guest_user?
      role.in?(guest_user_roles)
    end

    module ClassMethods
      def manageable_roles
        @_manageable_roles ||= roles.except(*manageless_roles)
      end

      def super_user_roles
        @_super_user_roles ||= config.super_user_roles.try(:map, &:to_s) || []
      end

      def guest_user_roles
        @_guest_users ||= config.guest_user_roles.try(:map, &:to_s) || []
      end

      private

        def manageless_roles
          (super_user_roles + guest_user_roles).flatten.compact
        end

        def config
          ::ActiveAdminRole.config
        end
    end
  end
end
