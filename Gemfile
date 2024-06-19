# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma'
gem 'rack-session'
gem 'redis-rack' # , git: 'https://github.com/redis-store/redis-rack'
gem 'redis-store' # , git: 'https://github.com/PikachuEXE/redis-store', branch: 'fix/redis-client-compatibility'
gem 'roda'
gem 'secure_headers'
gem 'slim'

# Configuration
gem 'figaro'
gem 'hirb'
gem 'pkg-config'
gem 'rake'

# Debugging
gem 'pry'
gem 'redis'

# Communication
gem 'geocoder'
gem 'http'

# Security
gem 'base64'
gem 'dry-validation'
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed

# Testing
group :test do
  gem 'minitest'
  gem 'minitest-rg'
  gem 'webmock'
end

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'rack-test'
  gem 'rerun'
end
