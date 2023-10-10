source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.0"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.7"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Fast, simple and easy to use JSON:API serialization library
gem 'jsonapi-serializer', '~> 2.2'

# Clean ruby syntax for writing and deploying cron jobs
gem 'whenever', '~> 1.0'

# Autoload dotenv in Rails
gem 'dotenv-rails', '~> 2.8', '>= 2.8.1'

# The CSV library provides a complete interface to CSV files and data
gem 'csv', '~> 3.2', '>= 3.2.7'

# Fast, simple and easy to use JSON:API serialization library
gem 'jsonapi-serializer', '~> 2.2'


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]

  # Pry is a runtime developer console and IRB alternative with powerful introspection capabilities.
  gem 'pry', '~> 0.14.2'

  # Adds 'step', 'next', 'finish', 'continue' and 'break' commands to control execution
  gem 'pry-byebug', '~> 3.10', '>= 3.10.1'

  # Use Pry as your rails console
  gem 'pry-rails', '~> 0.3.9'

  # Testing framework for Rails
  gem 'rspec-rails'

  # Factory_bot_rails provides integration between factory_bot and rails 5.0 or newer
  gem 'factory_bot_rails', '~> 6.2'

  # Faker, a port of Data::Faker from Perl, is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem 'faker', '~> 3.2', '>= 3.2.1'

  # Shoulda Matchers provides RSpec- and Minitest-compatible one-liners to test common Rails functionality
  gem 'shoulda-matchers', '~> 5.3'

  # Code coverage for Ruby with a powerful configuration library and automatic merging of coverage across test suites
  gem 'simplecov', '~> 0.22.0'
end
