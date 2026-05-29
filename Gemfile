source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "propshaft"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false
gem "image_processing", "~> 2.0"

# Authentication
gem "devise"
gem "bcrypt", "~> 3.1.7"

# Authorization
gem "pundit"

# Background jobs
gem "sidekiq"
gem "sidekiq-scheduler"

# Pagination
gem "pagy", "~> 9.0"

# Search
gem "pg_search"

# File uploads
gem "active_storage_validations"

# Money handling
gem "money-rails", "~> 1.15"

# Environment variables
gem "dotenv-rails"

# Brazilian documents validation
gem "cpf_cnpj"

# PDF generation
gem "prawn"
gem "prawn-table"

# Excel export
gem "caxlsx_rails"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "factory_bot_rails"
  gem "faker"
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
  gem "annotate"
  gem "bullet"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
