require 'database_cleaner'

RSpec.configure do |config|

  # config.before(:suite) do
  #   DatabaseCleaner.strategy = :transaction
  #   DatabaseCleaner.clean_with(:truncation)
  #   Redis.new.flushdb
  #   Doctor.__elasticsearch__.create_index!(force: true)
  # end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
    Redis.new.flushdb
    Pharmacy.__elasticsearch__.create_index!(force: true)
    Doctor.__elasticsearch__.create_index!(force: true)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
