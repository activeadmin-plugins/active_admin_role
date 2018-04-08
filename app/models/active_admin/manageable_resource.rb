require "set"

module ActiveAdmin
  class ManageableResource
    class << self
      def call
        new.call
      end
    end

    def call
      namespace = ::ActiveAdmin.application.default_namespace
      ::ActiveAdmin.application.namespaces[namespace].resources.inject([]) do |result, resource|
        class_name = resource.controller.resource_class.to_s
        name       = resource.resource_name.name
        actions    = collect_defined_actions(resource)

        result += eval_actions(actions).map do |action|
          { class_name: class_name, name: name, action: action }
        end

        result
      end
    end

    private

      def collect_defined_actions(resource)
        if resource.respond_to?(:defined_actions)
          defined_actions    = resource.defined_actions
          member_actions     = resource.member_actions.map(&:name)
          collection_actions = resource.collection_actions.map(&:name)
          batch_actions      = resource.batch_actions_enabled? ? [:batch_action] : []

          defined_actions | member_actions | member_actions | collection_actions | batch_actions
        else
          resource.page_actions.map(&:name) | [:index]
        end
      end

      def eval_actions(actions)
        actions.inject(Set.new) do |result, action|
          result << (actions_dictionary[action] || action).to_s
        end
      end

      def actions_dictionary
        @_actions_dictionary ||= ::ActiveAdmin::BaseController::Authorization::ACTIONS_DICTIONARY.dup
      end
  end
end
