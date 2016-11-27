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
