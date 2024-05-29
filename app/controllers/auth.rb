# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('auth') do |routing|
      @login_route = '/auth/login'
      @register_route = '/auth/register'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login
        end

        # POST /auth/login
        routing.post do
          account_info = Cryal::AuthService.new(App.config).authenticate(routing)

          current_account = Account.new(
            account_info["account"],
            account_info["auth_token"]
          )
          CurrentSession.new(session).current_account = current_account
          flash[:notice] = "Welcome to NaviTogether #{current_account.username}!"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :login
        end
      end

      routing.on 'register' do
        routing.get(String) do |rt|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(rt)
          view :createpassword,
                locals: { new_account: , rt: }
        end

        routing.get do
          view :createaccount
        end

        routing.post do
          account_data = routing.params.transform_keys(&:to_sym)
          Cryal::VerifyRegistration.new(App.config).call(account_data)
          flash[:notice] = 'Please verify your email!'
          routing.redirect @login_route
          # do the services somthing
        rescue StandardError
          flash.now[:error] = 'Failed to create account'
          response.status = 400
          view :createaccount
        end

      end

      routing.on 'logout' do
        routing.get do
          # session[:current_account] = nil
          CurrentSession.new(session).delete
          routing.redirect @login_route
        end
      end
    end
  end
end
