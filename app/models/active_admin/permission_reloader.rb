module ActiveAdmin
  module PermissionReloader
    class << self
      def reload
        ActiveRecord::Base.transaction do
          clear_cache
          update_managed_resources
          cleanup_managed_resources
          update_permissions
        end
      end

      private

        def clear_cache
          @manageable_resources = nil
        end

        def update_managed_resources
          manageable_resources.each do |manageable_resource|
            ::ActiveAdmin::ManagedResource.find_or_create_by!(manageable_resource)
          end
        end

        def cleanup_managed_resources
          (persisted_resources - manageable_resources).each do |condition|
            ::ActiveAdmin::ManagedResource.where(condition).destroy_all
          end
        end

        def update_permissions
          ::ActiveAdmin::Permission.clear_cache
          ::ActiveAdmin::Permission.update_all_from_managed_resources
        end

        def persisted_resources
          ::ActiveAdmin::ManagedResource.all.map(&:attributes).map do |attribute|
            attribute.slice("class_name", "action", "name").symbolize_keys
          end
        end

        def manageable_resources
          @manageable_resources ||= ::ActiveAdmin::ManageableResource.call
        end
    end
  end
end
