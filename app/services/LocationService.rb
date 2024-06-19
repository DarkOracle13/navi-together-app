# frozen_string_literal: true

require 'http'
require 'geocoder'

module Cryal
  # Location Service
  class LocationService
    class PermissionDenied < StandardError; end
    class PositionUnavailable < StandardError; end
    class Timeout < StandardError; end
    class LocationSystemError < StandardError; end

    def initialize(config)
      @config = config
    end

    def create_location(_routing, current_account, request_data) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      # # /api/v1/locations
      request_data['latitude']
      request_data['longitude']
      address = request_data['address']
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.post("#{@config.API_URL}/locations",
                           json: { latitude: request_data['latitude'].to_s, longitude: request_data['longitude'].to_s,
                                   cur_address: address, cur_name: nil }, headers:)

      raise(LocationSystemError) unless response.code == 201

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      location_data = data
      puts "The location data is #{location_data}"
      location_data
    end
  end
end
