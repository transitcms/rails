source "http://rubygems.org"

gem 'combustion', '~> 0.3.1', :group => :development

group :test do
  gem 'mongoid-rspec', '1.5.4', :require => 'mongoid-rspec'
  gem 'simplecov', :require => false
  gem 'rake'
  gem 'growl'
  gem 'guard', '1.3.0'
  gem "guard-rspec"
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'machinist_mongo', github: 'brentkirby/machinist_mongo', require: 'machinist/mongoid'
  gem 'poltergeist', '1.1.0'
  gem "konacha", "~>2.5"
end

group :assets do
  gem 'sass-rails',   '~> 3.2'
  gem 'coffee-rails', '~> 3.2'
  gem 'jquery-rails'
  gem 'uglifier'
  gem 'coffee-script', '2.2.0'
  gem "bootstrap-sass"
end

gemspec
