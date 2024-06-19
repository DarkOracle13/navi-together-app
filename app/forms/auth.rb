# frozen_string_literal: true

require_relative 'form_base'

module Cryal
  module Form
    # Auth Form Login Credentials
    class LoginCredentials < Dry::Validation::Contract
      puts params
      params do
        required(:username).filled
        required(:password).filled
      end
    end

    # Auth Form Registration
    class Registration < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_detail.yml')

      params do
        required(:username).filled(format?: USERNAME_REGEX, min_size?: 8) # make it easuer to debug no long username
        required(:email).filled(format?: EMAIL_REGEX)
      end
    end

    # Auth Form Passwords
    class Passwords < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/password.yml')

      params do
        required(:password).filled
        required(:confirmpassword).filled
      end

      def enough_entropy?(string)
        StringSecurity.entropy(string) >= 3.0
        # StringSecurity.entropy(string) >= 0.0 #make it easier to debug no complicated password
        # true
      end

      rule(:password) do
        key.failure('Password must be more complex') unless enough_entropy?(value)
      end

      rule(:password, :confirmpassword) do
        key.failure('Passwords do not match') unless values[:password].eql?(values[:confirmpassword])
      end
    end
  end
end
