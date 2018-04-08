source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gemspec

gem "appraisal"
gem "devise"
gem "jquery-ui-rails", "~> 6.0.1"
gem "rails", ">= 5.0.0"

group :development, :test do
  gem "sqlite3", platforms: :mri
end

group :development do
  gem "onkcop", require: false
end

group :test do
  gem "capybara"
  gem "database_cleaner"
  gem "poltergeist"
  gem "rspec-rails"
  gem "shoulda-matchers"
end
