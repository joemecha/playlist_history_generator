source "https://rubygems.org"

ruby "3.2.2"

gem "rails", "~> 7.2.2", ">= 7.2.2.2"
gem "pg"
gem "puma", "~> 6.6"
gem "importmap-rails", "~> 2.2.2"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false

gem 'devise'
gem 'dotenv-rails'
gem 'faraday'
gem 'kaminari'
gem 'nokogiri' # HTML parser
gem 'pundit'

gem 'sprockets-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
# gem "stimulus-rails"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", ">= 4.0.1"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry'
  gem 'shoulda-matchers'
  gem 'simplecov'
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[ mri windows ]
end

group :development do
  gem "annotate", "~> 3.2"
  gem 'brakeman', require: false
  gem "web-console"
end

group :test do
  gem 'webmock'
# add if/when needed
  # gem 'capybara'
  # gem 'selenium-webdriver'
end

