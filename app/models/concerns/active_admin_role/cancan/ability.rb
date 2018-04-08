module ActiveAdminRole
  module CanCan
    module Ability
      extend ActiveSupport::Concern

      private

        def register_role_based_abilities(user)
          return if user.guest_user?

          (::ActiveAdmin::Permission.indexed_cache[user.role] || []).select(&:active?).each do |permission|
            send(*permission.to_condition)
          end
        end
    end
  end
end
