require 'http'
require 'geocoder'

module Cryal
    class LocationService
        class PermissionDenied < StandardError; end
        class PositionUnavailable < StandardError; end
        class Timeout < StandardError; end
        class LocationSystemError < StandardError; end
        def initialize(config)
            @config = config
        end

        
        def create_location(routing, current_account, request_data)
            # # /api/v1/locations
            latitude = request_data["latitude"]
            longitude = request_data["longitude"]
            location_code = Geocoder.search([latitude, longitude]).first
            headers = { 'Authorization' => "Bearer #{current_account.auth_token}", 'Content-Type' => 'application/json' }
            response = HTTP.post("#{@config.API_URL}/locations",
                            json: {latitude: request_data['latitude'].to_s, longitude: request_data['longitude'].to_s,
                                    cur_address: location_code.address, cur_name: nil}, headers: headers)

            raise(LocationSystemError) unless response.code == 201

            body = JSON.parse(response.body)
            data = body['data'] if body['data']
            location_data = data
            puts "The location data is #{location_data}"
            location_data
        end
    end
end