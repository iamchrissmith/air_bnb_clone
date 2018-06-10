source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.0.5'
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
gem 'uglifier', '= 3.2.0'
gem 'coffee-rails', '~> 4.2', '>= 4.2.2'
gem 'active_model_serializers', '~> 0.10.6'
gem 'jquery-rails', '>= 4.3.1'
gem 'jquery-turbolinks', '>= 2.1.0'
gem 'jquery-validation-rails'
gem 'jbuilder', '~> 2.5'
gem 'will_paginate', '~> 3.1.0'
gem 'figaro'
gem 'faraday'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2', '<= 0.5.0'
gem 'simplecov', :require => false, :group => :test
gem 'geocoder'
gem 'chart-js-rails', '>= 0.1.3'
# gem 'bcrypt', '~> 3.1.7'

# , :git => 'git://github.com/stympy/faker.git', :branch => 'master'
gem 'faker'
gem 'devise', '>= 4.3.0'
gem 'bootstrap-sass'
gem 'bootstrap-social-rails', '>= 4.12.0'
gem 'font-awesome-rails', '>= 4.7.0.2'
gem 'redis', '~>3.2'
gem 'newrelic_rpm'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '>= 3.6.0'
  gem 'pry-rails'
  gem 'rspec-pride'
  gem 'awesome_print', require: 'ap'
  gem 'capybara', '>= 2.14.4'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '>= 4.8.0'
  gem 'shoulda-matchers'
  gem 'selenium-webdriver'
  gem 'newrelic_rpm'
end

group :test do
  gem 'vcr'
  gem 'webmock'
  gem 'timecop'
end

group :development do
  gem 'web-console', '>= 3.5.1'
  gem 'listen', '~> 3.0.5'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
