# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('auth') do |routing|
        @login_route = '/auth/login'
        routing.is 'login' do
          # GET /auth/login
          routing.get do
            view :login
          end

          # POST /auth/login
          routing.post do
            account = Cryal::AuthService.authenticate(routing)
            # if account
            #   session[:current_account] = account.id
            #   flash[:notice] = 'Login successful'
            #   routing.redirect '/'
            # else
            #   flash.now[:error] = 'Login failed'
            #   view :login
            # end
          end
        end
    end
end
end