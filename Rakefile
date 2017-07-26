# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

desc 'Scrub VCR Cassettes'
namespace :vcr do
  task :scrub do
    sh %{ rm -rf spec/fixtures/vcr_cassettes/ }
  end
end
