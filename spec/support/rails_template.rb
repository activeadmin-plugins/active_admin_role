# == Configure default_url_options in test environment
# inject_into_file "config/environments/test.rb",
#                  "  config.action_mailer.default_url_options = { host: 'example.com' }\n",
#                  after: "config.cache_classes = true\n"

# == Add our local Active Admin to the load path
# inject_into_file "config/environment.rb",
#                  %($LOAD_PATH.unshift('#{File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))}')\nrequire "active_admin"\n),
#                  after: Rails::VERSION::MAJOR >= 5 ? "require_relative 'application'" : "require File.expand_path('../application', __FILE__)"

run "rm Gemfile"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

# == Prepare Active Admin
generate :"active_admin:install"

# == Prepare Active Admin Role
generate :"active_admin_role:install"

run "rm -r spec"
run "rm -r test"

route "root to: 'admin/dashboard#index'"

rake "db:migrate"
