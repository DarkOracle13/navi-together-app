# frozen_string_literal: true

require 'http'

module Cryal
  # Returns an authenticated user, or nil
  class VerifyRegistration
    class VerificationError < StandardError; end
    class ApiServerError < StandardError; end

    def initialize(config)
      @config = config
    end

    def call(account_data)
      # registration_data = { email: routing.params['email'],
      #                       username: routing.params['username'] }
      registration_token = SecureMessage.encrypt(account_data)
      account_data['verification_url'] =
        "#{@config.APP_URL}/auth/register/#{registration_token}"
      response = HTTP.post(
        "#{@config.API_URL}/auth/register",
        json: account_data
      )
      raise(VerificationError) unless response.code == 202

      JSON.parse(response.to_s)
    rescue HTTP::ConnectionError
      raise(ApiServerError)
    end
  end
end
