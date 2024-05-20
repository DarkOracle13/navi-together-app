# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('account') do |routing|
      @account_name = @current_account['username']
      routing.is @account_name do
        if @current_account
            view :account_page, locals: { current_account: @current_account }
          else
            routing.redirect '/auth/login'
          end
      end
    end
  end
end
