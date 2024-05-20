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
          account = Cryal::AuthService.new(App.config).authenticate(routing)
          session[:current_account] = account
          flash[:notice] = "Welcome to NaviTogether #{account['username']}"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :login
        end
      end

      routing.is 'register' do
        routing.get do
          puts "masuk page register"
          view :createaccount
        end

        routing.post do
          # account_data = routing.params.transform_keys(&:to_sym)
          # new_account = Cryal::CreateAccount.new(App.config).call(**account_data)
          puts "masuk post register"
          puts routing.params['email']
          puts routing.params['username']
          puts routing.params['password']
          Cryal::CreateAccount.new(App.config).call(routing)
          flash[:notice] = 'Please login with your new account information'
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
          session[:current_account] = nil
          routing.redirect @login_route
        end
      end
    end
  end
end
