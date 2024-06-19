# frozen_string_literal: true

require 'http'

module Cryal
  # Authentication Service
  class AuthService
    class UnauthorizedError < StandardError; end

    def initialize(config)
      @config = config
    end

    def authenticate(routing)
      credentials = { username: routing.params['username'], password: routing.params['password'] }

      response = HTTP.post("#{ENV['API_URL']}/auth/authentication", json: SignedMessage.sign(credentials))

      # response = HTTP.post("#{@config.API_URL}/auth/authentication",
      #                 json: { username: routing.params['username'], password: routing.params['password']})

      raise(UnauthorizedError) unless response.code == 200

      body = JSON.parse(response.body)
      body['attributes']
    end
  end

  # Class to authorize Github account
  class AuthorizeGithubAccount
    # Errors emanating from Github
    class UnauthorizedError < StandardError
      def message
        'Could not login with Github'
      end
    end

    def initialize(config)
      @config = config
    end

    def call(code)
      access_token = get_access_token_from_github(code)
      get_sso_account_from_api(access_token)
    end

    private

    def get_access_token_from_github(code)
      challenge_response =
        HTTP.headers(accept: 'application/json')
            .post(@config.GH_TOKEN_URL,
                  form: { client_id: @config.GH_CLIENT_ID,
                          client_secret: @config.GH_CLIENT_SECRET,
                          code: })
      raise UnauthorizedError unless challenge_response.status < 400

      JSON.parse(challenge_response)['access_token']
    end

    def get_sso_account_from_api(access_token)
      # response = HTTP.post("#{@config.API_URL}/auth/sso",
      #             json: { access_token: access_token })
      signed_sso_info = { access_token: }.then { |sso_info| SignedMessage.sign(sso_info) }
      response = HTTP.post("#{@config.API_URL}/auth/sso", json: signed_sso_info)

      raise if response.code >= 400

      body = JSON.parse(response.body)
      body['data']['attributes']
    end
  end
end
