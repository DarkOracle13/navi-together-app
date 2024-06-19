# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    def gh_oauth_url(config)
      url = config.GH_OAUTH_URL
      client_id = config.GH_CLIENT_ID
      scope = config.GH_SCOPE

      "#{url}?client_id=#{client_id}&scope=#{scope}"
    end

    route('auth') do |routing| # rubocop:disable Metrics/BlockLength
      @login_route = '/auth/login'
      @register_route = '/auth/register'
      routing.is 'login' do
        # GET /auth/login
        routing.get do
          view :login, locals: { gh_oauth_url: gh_oauth_url(App.config) }
        end

        # POST /auth/login
        routing.post do
          formcheck = Form::LoginCredentials.new.call(routing.params)

          if formcheck.failure?
            flash[:error] = 'Please Enter Username and Password'
            routing.redirect @login_route
          end

          account_info = Cryal::AuthService.new(App.config).authenticate(routing)

          current_account = Account.new(
            account_info['account'],
            account_info['auth_token']
          )
          CurrentSession.new(session).current_account = current_account
          flash[:notice] = "Welcome to NaviTogether #{current_account.username}!"
          routing.redirect '/'
        rescue StandardError
          flash.now[:error] = 'Username and password did not match our records'
          response.status = 400
          view :login, locals: { gh_oauth_url: gh_oauth_url(App.config) }
        end
      end

      routing.on 'register' do # rubocop:disable Metrics/BlockLength
        routing.get(String) do |rt|
          flash.now[:notice] = 'Email Verified! Please choose a new password'
          new_account = SecureMessage.decrypt(rt)
          view :createpassword,
               locals: { new_account:, rt: }
        end

        routing.is do
          routing.get do
            view :createaccount
          end

          routing.post do
            formcheck = Form::Registration.new.call(routing.params)
            if formcheck.failure?
              flash[:error] = Form.validation_errors(formcheck)
              routing.redirect @register_route
            end

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
      end

      # GET /auth/github_sso_callback
      routing.on 'github_sso_callback' do
        routing.get do
          authorized_account = Cryal::AuthorizeGithubAccount.new(App.config).call(routing.params['code'])
          # puts "authorized_account: #{authorized_account.inspect}"
          current_account = Account.new(
            authorized_account['account'],
            authorized_account['auth_token']
          )
          # puts "current_account: #{current_account.inspect}"
          CurrentSession.new(session).current_account = current_account
          flash[:notice] = "Welcome to NaviTogether #{current_account.username}!"
          routing.redirect '/'
        rescue AuthorizeGithubAccount::UnauthorizedError
          flash[:error] = 'Could not login with Github'
          routing.redirect @login_route
        rescue StandardError => e
          puts "FAILED to validate Github account: #{e.inspect}"
          puts e.backtrace
          flash[:error] = 'Could not login with Github'
          routing.redirect @login_route
        end
      end

      routing.on 'logout' do
        routing.is do
          routing.get do
            # session[:current_account] = nil
            CurrentSession.new(session).delete
            routing.redirect @login_route
          end
        end
      end
    end
  end
end
