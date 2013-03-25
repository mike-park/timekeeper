source 'https://rubygems.org'

gem 'rails', '3.2.12'
gem 'unicorn', "~> 4.5.0"
gem 'jquery-rails'
gem "haml", ">= 3.1.7"
gem "bootstrap-sass", ">= 2.2.2.0"
gem "sendgrid", ">= 1.0.1"
gem "devise", ">= 2.1.3"
gem "cancan", ">= 1.6.8"
gem "rolify", ">= 3.2.0"
gem "simple_form", ">= 2.0.4"
gem "figaro", ">= 0.5.0"

gem "jquery-ui-rails", "~> 3.0.1"
gem 'angularjs-rails', '~> 1.0.3'
gem "angularjs-rails-resource", '~> 0.0.2'
gem 'angular-ui-rails', '~> 0.3.2'
gem 'angular-ui-bootstrap-rails', '~> 0.1.1'
gem "fullcalendar-rails", "~> 1.5.4.0"
gem 'select2-rails', '~> 3.2.0'
gem 'inherited_resources', '~> 1.3.1'
gem "active_model_serializers", :git => "git://github.com/rails-api/active_model_serializers.git"
gem 'restful_json', '>= 3.0.0.alpha.27', :git => 'git://github.com/FineLinePrototyping/restful_json.git'
gem 'acts-as-taggable-on', '~> 2.3.1'
gem 'newrelic_rpm', '~> 3.5.5.38'
gem 'awesome_print'
gem 'draper'
# errbit error reporting. 3.1.7 doesn't work when current_user == nil
gem 'airbrake', '= 3.1.6'
gem 'momentjs-rails', '~> 1.7.2'
gem 'public_activity', '~> 1.0.2'
gem 'prawn', '~> 0.12.0'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'sqlite3'
  gem "rspec-rails", ">= 2.11.4"
  gem "factory_girl_rails", ">= 4.1.0"
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
