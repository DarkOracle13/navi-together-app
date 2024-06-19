# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('account') do |routing| # rubocop:disable Metrics/BlockLength
      @account_name = @current_account.username
      routing.on @account_name do
        if @current_account.logged_in?
          account_info = GetAccountDetails.new(App.config).call(@current_account, @account_name)
          view :account_page, locals: { data: account_info }
        else
          routing.redirect '/auth/login'
        end
      end

      routing.post String do |rt|
        formcheck = Form::Passwords.new.call(routing.params)
        raise Form.message_values(formcheck) if formcheck.failure?

        new_account = SecureMessage.decrypt(rt)
        CreateAccount.new(App.config).call(
          email: new_account['email'],
          username: new_account['username'],
          password: routing.params['password']
        )
        flash[:notice] = 'Account created! Please login'
        routing.redirect '/auth/login'
      rescue StandardError => e
        flash[:error] = e.message
        routing.redirect(
          "#{App.config.APP_URL}/auth/register/#{rt}"
        )
      end
    end
  end
end
