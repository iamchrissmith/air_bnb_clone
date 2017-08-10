namespace :build do
  desc "Builds app locally"
  task :all => [:db_drop, :dev_db_fill]

  desc "Builds app with testing"
  task :all_with_testing => [:db_drop, :dev_db_fill, :run_rspec]

  desc "Builds app, reseeds the database, and builds new postgres backup file"
  task :migrate_and_seed => [:db_drop, :db_migrate, :db_seed, :db_backup]

  desc "wipes database"
  task :db_drop do
    `bin/rails db:environment:set RAILS_ENV=development`
    Rails.env = "development"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
    Rails.env = "test"
    Rake::Task["db:drop"].invoke
    Rake::Task["db:create"].invoke
  end

  desc 'load db from backup'
  task :dev_db_fill do
    `psql fair_bnb_development < ./db/fair_bnb_db_backup`
    puts 'Development database has been filled.'
  end

  desc 'run test suite'
  task :run_rspec do
    Rake::Task["db:test:prepare"].invoke
    Rake::Task["spec"].invoke
  end

  desc 'runs migrations on database'
  task :db_migrate do
    Rake::Task["db:migrate"].invoke
  end

  desc 'seeds database'
  task :db_seed do
    Rake::Task["db:seed"].invoke
  end

  desc 'dumps postgres data into file'
  task :db_backup do
    `pg_dump fair_bnb_development > ./db/fair_bnb_db_backup`
    puts 'postgres dump successful'
  end

  desc 'integrates and deploys to production mode'
  task :integrate do
    system("bundle exec rake db:drop RAILS_ENV=production DISABLE_DATABASE_ENVIRONMENT_CHECK=1")
    system("bundle exec rake db:create RAILS_ENV=production")
    `psql fair_bnb_production < ./db/fair_bnb_db_backup`
    Rake::Task["assets:clobber"].invoke
    Rake::Task["assets:precompile"].invoke
    puts "please run 'rails server -e production'"
  end
end