require 'http'

module Cryal
    class AuthService
        class UnauthorizedError < StandardError; end

        def initialize(config)
            @config = config
        end

        def authenticate(routing)
            response = HTTP.post("#{@config.API_URL}/auth/authentication",
                            json: { username: routing.params['username'], password: routing.params['password']})

            raise(UnauthorizedError) unless response.code == 200
            body = JSON.parse(response.body)
            data = body['attributes']
            data
        end
    end
end
