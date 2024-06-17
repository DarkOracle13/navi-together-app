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
      registration_token = SecureMessage.encrypt(account_data)
      puts "registration_token: #{registration_token}"
      account_data['verification_url'] = "#{@config.APP_URL}/auth/register/#{registration_token}"
      puts "account_data: #{account_data}"
      puts "signed message: #{SignedMessage.sign(account_data)}"
      response = HTTP.post("#{@config.API_URL}/auth/register",json: SignedMessage.sign(account_data))
      puts "response: #{response}"
      
      raise(VerificationError) unless response.code == 202

      JSON.parse(response.to_s)
    rescue HTTP::ConnectionError
      raise(ApiServerError)
    end
  end
end
