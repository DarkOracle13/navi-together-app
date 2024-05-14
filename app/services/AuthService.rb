module Cryal
    module AuthService
        def self.authenticate(params)
            puts "Authenticating with #{params.params['username']} and #{params.params['password']}"
            # use logger to log the params
        end
    end
end