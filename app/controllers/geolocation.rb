# frozen_string_literal: true

require 'roda'
require_relative './app'
require 'geocoder'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('geolocation') do |routing|
      routing.redirect '/auth/login' unless @current_account.logged_in?

      routing.on 'locate' do
        routing.get do
          view :get_location, locals: { current_account: @current_account }
        end

        # POST
        routing.post do
          request_data = JSON.parse(routing.body.read)
          output = LocationService.new(App.config).create_location(routing, @current_account, request_data)
          response.status = 201
          flash.now[:notice] = 'Location saved'
          { message: 'Location saved', data: output }.to_json
        end
      end
    end
  end
end
