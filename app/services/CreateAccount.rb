# frozen_string_literal: true

require 'http'

module Cryal
  # Returns an authenticated user, or nil
  class CreateAccount
    class InvalidAccount < StandardError; end

    def initialize(config)
      @config = config
    end

    def call( email:, username:, password: )
      message = { email: ,
                  username: ,
                  password: }

      puts message
      puts "sending message"

      response = HTTP.post(
        "#{@config.API_URL}/accounts/",
        json: message
      )

      puts response
      raise InvalidAccount unless response.code == 201
    end
  end
end
