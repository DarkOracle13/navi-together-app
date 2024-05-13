# frozen_string_literal: true

source 'https://rubygems.org'

# Web
gem 'puma'
gem "rack-session"
gem 'roda'
gem 'slim'

# Configuration
gem 'figaro'
gem 'rake'
gem 'hirb'
gem 'pkg-config'

# Debugging
gem 'pry'
gem 'rerun'

# Communication
gem 'http'

# Security
gem 'rbnacl' # assumes libsodium package already installed
gem 'base64'

# Development
group :development do
  gem 'rubocop'
  gem 'rubocop-performance'
end

group :development, :test do
  gem 'rack-test'
  gem 'rerun'
end
