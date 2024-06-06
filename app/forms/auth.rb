# frozen_string_literal: true

require_relative 'form_base'

module Cryal
  module Form
    class LoginCredentials < Dry::Validation::Contract
      puts params
      params do
        required(:username).filled
        required(:password).filled
      end
    end

    class Registration < Dry::Validation::Contract
      config.messages.load_paths << File.join(__dir__, 'errors/account_detail.yml')

      params do
        required(:username).filled(format?: USERNAME_REGEX, min_size?: 8) #make it easuer to debug no long username
        required(:email).filled(format?: EMAIL_REGEX)
      end
    end

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
        unless enough_entropy?(value)
          key.failure('Password must be more complex')
        end
      end

      rule(:password, :confirmpassword) do
        unless values[:password].eql?(values[:confirmpassword])
          key.failure('Passwords do not match')
        end
      end
    end
  end
end
