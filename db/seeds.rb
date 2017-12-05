if Rails.env.production?
  require 'factory_girl_rails'
  # require Rails.root.join("db/seeds_basic").to_s
  require Rails.root.join("db/seeds_development").to_s

else

  require 'database_cleaner'
  require 'factory_girl_rails'
  require 'ffaker'

  DatabaseCleaner.strategy = :truncation
  DatabaseCleaner.clean

  redis = Redis.new
  redis.flushall

  require Rails.root.join("db/seeds_basic").to_s
  require Rails.root.join("db/seeds_development").to_s
  Doctor.__elasticsearch__.import
  Pharmacy.__elasticsearch__.import
end
