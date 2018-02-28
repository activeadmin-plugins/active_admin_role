$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH << File.expand_path("../support", __FILE__)

ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", __FILE__)

require "bundler"
Bundler.setup

ENV["RAILS_ENV"] = "test"

# == Ensure the Active Admin load path is happy
require "rails"

ENV["RAILS"] = Rails.version
ENV["RAILS_ROOT"] = File.expand_path("../rails/rails-#{ENV["RAILS"]}", __FILE__)

# == Create the test app if it doesn't exists
system "rake setup" unless File.exist?(ENV["RAILS_ROOT"])

# == Require ActiveRecord to ensure that Ransack loads correctly
require "active_record"
require "active_admin"

ActiveAdmin.application.load_paths = [ENV["RAILS_ROOT"] + "/app/admin"]

# == Load test app
require ENV["RAILS_ROOT"] + "/config/environment.rb"

# == RSpec
require "rspec/rails"

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:should, :expect]
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = [:should, :expect]
  end

  config.order = :random

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

# == Capybara
require "capybara/rails"
require "capybara/rspec"
require "capybara/poltergeist"

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, js_errors: true,
                                         timeout: 80,
                                         debug: false,
                                         phantomjs_options: ["--debug=no", "--load-images=no"])
end

Capybara.javascript_driver = :poltergeist

# == Shoulda Matchers
require "shoulda-matchers"

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :active_record
    with.library :active_model
    with.library :rails
  end
end

# == Support
def prepare_admin_users
  AdminUser.roles.each_key do |role|
    AdminUser.find_or_create_by(email: "#{role}@example.com", role: role) do |admin_user|
      admin_user.password = "password"
      admin_user.password_confirmation = "password"
    end
  end
end

def login_as(role)
  visit root_path
  fill_in "admin_user_email",    with: "#{role}@example.com"
  fill_in "admin_user_password", with: "password"
  click_button "Login"
end

def logout
  click_link "Logout"
end
