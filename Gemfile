source 'https://rubygems.org'

ruby '2.4.0'

gem 'rails', '5.0.6'
gem 'pg', '~> 0.18'

gem 'puma', '~> 3.0'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'bootstrap-sass', '~> 3.3.6'

gem 'font-awesome-rails'

gem 'jquery-rails'
gem 'enumerize', '~> 2.0.0'
gem 'aasm'

gem 'active_model_serializers', '~> 0.10.0'

gem 'devise', '~> 4.1.1'
gem 'linkedin'
gem 'omniauth'
gem 'omniauth-oauth2'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-linkedin-oauth2'

gem 'simple_form'

gem 'kaminari'

gem 'twilio-ruby', '~> 4.11.1'
gem 'dotenv-rails', require: 'dotenv/rails-now'

gem 'elasticsearch-model'
gem 'elasticsearch-rails'

gem 'carrierwave'
gem 'mini_magick'

# gem "fog-aws", '2.0.0'

gem 'carmen'
gem 'carmen-rails', '~> 1.0.0'

gem 'sidekiq'
# Sinatra's current version is 1.4.7 which depends on rack ~> 1.5. But we need rack ~> 2.0 in other
# gems. That's why we use master branch
gem 'sinatra', git: 'https://github.com/sinatra/sinatra.git', require: nil
gem 'sidekiq-statistic'
gem 'sidekiq-failures'

gem 'redis'
gem 'bcrypt', '~> 3.1.7'

gem 'json-schema', '~> 2.5'

gem 'appointment_queue', path: 'lib/gems/appointment_queue'

gem 'fcm'
# Stripe Payment gateway
gem 'stripe'

# Integrate React, support server side rendering
gem 'react_on_rails'
gem 'therubyracer', platforms: :ruby

gem 'dry-validation'

# Monitoring performance
gem 'newrelic_rpm'
gem 'rails_12factor', group: :production

group :development, :test, :staging do
  gem 'pry-rails', '~> 0.3.4'
  gem 'factory_girl_rails', '~> 4.6.0', require: false
  gem 'rspec-rails', '~> 3.5.0', require: false
  gem 'rspec', '~> 3.5.0', require: false
  gem 'spring-commands-rspec'
  gem 'database_cleaner', require: false
  gem 'ffaker', '~> 2.2.0', require: false
  gem 'reek', require: false
end

group :development do
  gem 'foreman'
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano-rails'
  gem 'capistrano3-puma'
  gem 'capistrano-sidekiq'
  gem 'capistrano-rvm'
end

group :test do
  gem 'rails-controller-testing'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
