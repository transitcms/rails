source "http://rubygems.org"

gem 'combustion', '~> 0.3.1', :group => :development

group :test do
  gem 'growl'
  gem 'guard', '0.8.8'
  gem "spork", "~> 0.9.0.rc"
  gem "guard-rspec"
  gem 'machinist_mongo', git: "git://github.com/nmerouze/machinist_mongo.git", branch: "machinist2", require: "machinist/mongoid"
end

# Specify your gem's dependencies in transit.gemspec
gemspec
