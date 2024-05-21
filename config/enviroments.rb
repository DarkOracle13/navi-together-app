# frozen_string_literal: true

require 'roda'
require 'figaro'
require 'logger'
require 'rack/session'
require 'rack/ssl-enforcer'

module Cryal
  # Configuration for the API 
  class App < Roda
    plugin :environments

    # Environment variables setup
    Figaro.application = Figaro::Application.new(
      environment:,
      path: File.expand_path('config/secrets.yml')
    )
    Figaro.load
    def self.config = Figaro.env

    # Session configuration
    # IF YOU WANT TO USE SESSIONS, UNCOMMENT THIS BLOCK
    # ONE_MONTH = 30 * 24 * 60 * 60
    # use Rack::Session::Cookie,
    #     expire_after: ONE_MONTH,
    #     secret: config.SESSION_SECRET

    # Redis configuration
    ONE_MONTH = 30 * 24 * 60 * 60
    @redis_url = ENV.delete('REDISCLOUD_URL')
    SecureMessage.setup(ENV.delete('MSG_KEY'))
    SecureSession.setup(@redis_url) # only used in dev to wipe session store

    # HTTP Request logging
    configure :development, :production do
      plugin :common_logger, $stdout
    end

    # Custom events logging
    LOGGER = Logger.new($stderr)
    def self.logger = LOGGER

    configure :development, :test do
      logger.level = Logger::ERROR
    end

    # Console/Pry configuration
    configure :development, :test do
      require 'pry'

      # Allows running reload! in pry to restart entire app
      def self.reload!
        exec 'pry -r ./spec/test_load_all'
      end
    end

    configure :production do
      use Rack::SslEnforcer, hsts: true
    end
  end
end