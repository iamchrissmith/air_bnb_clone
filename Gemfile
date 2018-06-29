source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.2'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'uglifier', '= 3.2.0'
gem 'coffee-rails', '~> 4.2'
gem 'active_model_serializers', '~> 0.10.0'
gem 'jquery-rails'
gem 'jquery-turbolinks'
gem 'jquery-validation-rails'
gem 'jbuilder', '~> 2.5'
gem 'will_paginate', '~> 3.1.0'
gem 'figaro'
gem 'faraday'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', '<= 0.5.0'
gem 'simplecov', :require => false, :group => :test
gem 'geocoder'
gem 'chart-js-rails'
# gem 'bcrypt', '~> 3.1.7'

# , :git => 'git://github.com/stympy/faker.git', :branch => 'master'
gem 'faker'
gem 'devise'
gem 'bootstrap-sass', '>= 3.3.7'
gem 'bootstrap-social-rails'
gem 'font-awesome-rails'
gem 'redis', '~>3.2'
gem 'newrelic_rpm'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'rspec-pride'
  gem 'awesome_print', require: 'ap'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver', '>= 3.4.4'
  gem 'newrelic_rpm'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'timecop'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '~> 3.0.8'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
