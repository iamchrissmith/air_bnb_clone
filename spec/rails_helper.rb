ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'spec_helper'
require 'rspec/rails'
require 'awesome_print'
require 'support/factory_girl'
require 'database_cleaner'

DatabaseCleaner.strategy = :truncation
RSpec.configure do |c|
  c.before(:all) do
    DatabaseCleaner.clean
  end
  c.after(:each) do
    DatabaseCleaner.clean
  end
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.configure_rspec_metadata!
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.filter_sensitive_data('<FACEBOOK_KEY>') { ENV['FACEBOOK_KEY'] }
  config.filter_sensitive_data('<FACEBOOK_SECRET>') { ENV['FACEBOOK_SECRET'] }
  config.filter_sensitive_data('<FACEBOOK_USER_TOKEN>') { ENV['FACEBOOK_USER_TOKEN'] }
  config.filter_sensitive_data('<GOOGLE_CLIENT_ID>') { ENV['GOOGLE_CLIENT_ID'] }
  config.filter_sensitive_data('<GOOGLE_CLIENT_SECRET>') { ENV['GOOGLE_CLIENT_SECRET'] }
  config.filter_sensitive_data('<GOOGLE_USER_TOKEN>') { ENV['GOOGLE_USER_TOKEN'] }
  config.allow_http_connections_when_no_cassette = true
end

def stub_facebook
  OmniAuth.config.test_mode = true

  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    privider: 'facebook',
    uid: '12345',
    info:{
      email: 'ward.colleen.a@gmail.com',
      first_name: 'Colleen',
      last_name: 'Ward',
      image: "http://graph.facebook.com/v2.6/10100295829467675/picture",
      verified: true
    },
    credentials: {
      token: ENV['FACEBOOK_USER_TOKEN'],
      expires_at: 1500312576,
      expires: true
    }
    })

end

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
