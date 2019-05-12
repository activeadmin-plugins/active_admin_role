require File.join(File.dirname(__FILE__), "lib", "active_admin_role", "version")

Gem::Specification.new do |gem|
  gem.name          = "active_admin_role"
  gem.version       = ActiveAdminRole::VERSION
  gem.authors       = ["Yoshiyuki Hirano"]
  gem.email         = ["yhirano@me.com"]

  gem.summary       = "Role based authorization with CanCanCan for Active Admin"
  gem.description   = gem.summary
  gem.homepage      = "https://github.com/activeadmin-plugins/active_admin_role"
  gem.license       = "MIT"

  gem.files         = `git ls-files -z`.split("\x0").reject {|f| f.match(%r{^(test|spec|features)/}) }
  gem.require_paths = ["lib"]

  gem.required_ruby_version = ">= 2.2.2"

  gem.add_dependency "activeadmin", ">= 1.2.0"
  gem.add_dependency "cancancan",   ">= 1.15.0"
  gem.add_dependency "railties",    ">= 5.0.0"
end
