# frozen_string_literal: true

source 'https://rubygems.org'
ruby File.read('.ruby-version').strip

# Web
gem 'puma'
gem 'rack-session'
gem 'roda'
gem 'slim'
gem 'redis-rack' #, git: 'https://github.com/redis-store/redis-rack'
gem 'redis-store' #, git: 'https://github.com/PikachuEXE/redis-store', branch: 'fix/redis-client-compatibility'

# Configuration
gem 'figaro'
gem 'rake'
gem 'hirb'
gem 'pkg-config'

# Debugging
gem 'pry'
gem 'rerun'
gem 'redis'

# Communication
gem 'http'
gem 'geocoder'

# Security
gem 'dry-validation'
gem 'rack-ssl-enforcer'
gem 'rbnacl' # assumes libsodium package already installed
gem 'base64'

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
