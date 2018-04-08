require "active_admin"

module ActiveAdminRole
  def self.configure
    yield(config)
  end

  def self.config
    @config ||= Config.new
  end
end

require "active_admin_role/config"
require "active_admin_role/engine" if defined?(Rails)
