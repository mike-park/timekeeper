source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.12'
gem 'unicorn', "~> 4.5.0"
gem 'jquery-rails'
gem "haml", ">= 3.1.7"
gem "sendgrid", ">= 1.0.1"
gem "devise", ">= 2.1.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", "~> 2.1.0"

gem "jquery-ui-rails", "~> 3.0.1"
gem 'angularjs-rails', '~> 1.2.1'
gem "angularjs-rails-resource", '~> 0.2.4'
gem 'angular-ui-rails', '~> 0.3.2'

# bootstrap3
gem "bootstrap-sass", "~> 3.0.2.0"
gem 'angular-ui-bootstrap-rails', github: 'mike-park/angular-ui-bootstrap-rails', branch: 'bootstrap3'

gem 'angular-ng-grid-rails', '~> 2.0.7.2'
gem 'd3_rails'
gem "fullcalendar-rails", "~> 1.5.4.0"
gem 'select2-rails', '~> 3.5.1'
gem 'inherited_resources', '~> 1.3.1'
gem 'strong_parameters', '~> 0.2.1'
gem "active_model_serializers", '~> 0.8.1'
gem 'acts-as-taggable-on', '~> 2.3.1'
gem 'newrelic_rpm', '~> 3.5.5.38'
gem 'awesome_print'
gem 'draper'
# errbit error reporting. 3.1.7 doesn't work when current_user == nil
gem 'airbrake', '= 3.1.6'
gem 'momentjs-rails', '~> 1.7.2'
gem 'public_activity', '~> 1.0.2'
gem 'prawn', '~> 0.12.0'
gem 'twilio-ruby', '~> 3.9.0'
gem 'dalli', '~> 2.6.4'
gem 'memcachier', '~> 0.0.2'

# lodash js library
gem 'lodash-rails', '~> 2.3.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3'
  gem "rspec-rails", ">= 2.11.4"
  gem "factory_girl_rails", ">= 4.1.0"
  gem 'dotenv-rails', '~> 0.8.0'
end


group :development do
  gem "haml-rails", ">= 0.3.5"
  gem "hpricot", ">= 0.8.6"
  gem "ruby_parser", ">= 3.1.1"
  gem "quiet_assets", ">= 1.0.1"
  # this does not work with airbrake
  gem "better_errors", ">= 0.3.2"
  gem "binding_of_caller", ">= 0.6.8"
end

group :test do
  gem "capybara", ">= 2.0.1"
  gem "database_cleaner", ">= 0.9.1"
  gem "email_spec", ">= 1.4.0"
end

group :production do
  gem 'pg'
end
