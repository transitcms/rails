source "http://rubygems.org"

gem 'combustion', '~> 0.3.1', :group => :development

group :test do
  gem 'mongoid-rspec', git: "git://github.com/evansagge/mongoid-rspec.git", :require => 'mongoid-rspec'
  gem 'simplecov', :require => false
  gem 'rake'
  gem 'growl'
  gem 'guard', '0.8.8'
  gem "guard-rspec"
  gem 'machinist_mongo', git: "git://github.com/nmerouze/machinist_mongo.git", branch: "machinist2", require: "machinist/mongoid"
end

gemspec
