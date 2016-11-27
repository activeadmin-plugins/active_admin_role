module ActiveAdmin
  class ManagedResource < ActiveRecord::Base
    self.table_name = :active_admin_managed_resources

    has_many :permissions, dependent: :destroy

    with_options presence: true do
      validates :class_name
      validates :action
    end

    def const
      @_const ||= class_name.try(:safe_constantize)
    end

    def active?
      !const.nil?
    end

    def for_active_admin_page?
      class_name == "ActiveAdmin::Page"
    end

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

      def update_managed_resources
        manageable_resources.each(&method(:find_or_create_by!))
      end

      def cleanup_managed_resources
        (persisted_resources - manageable_resources).each do |condition|
          where(condition).destroy_all
        end
      end

      def update_permissions
        ::ActiveAdmin::Permission.clear_cache
        ::ActiveAdmin::Permission.update_all_from_managed_resources(all)
      end

      def persisted_resources
        all.map(&:attributes).map { |attribute| attribute.slice(*%w(class_name action name)).symbolize_keys }
      end

      def manageable_resources
        @_manageable_resources ||= ::ActiveAdminRole::ManageableResource.new.call
      end

      def clear_cache
        @_manageable_resources = nil
      end
    end
  end
end
