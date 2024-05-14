require 'http'

module Cryal
    class AuthService
        class UnauthorizedError < StandardError; end

        def initialize(config)
            @config = config
        end

        def authenticate(routing)
            response = HTTP.post("http://localhost:3000/api/v1/auth/authentication",
                            json: { username: routing.params['username'], password: routing.params['password']})

            raise(UnauthorizedError) unless response.code == 200

            body = JSON.parse(response.body)
            data = JSON.parse(body['data']) if body['data']
            data
        end
    end
end
