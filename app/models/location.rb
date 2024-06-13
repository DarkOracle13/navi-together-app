# frozen_string_literal: true

module Cryal
    # Behaviors of the room
    class Location
      def initialize(location_info)
        @location_info = location_info
        @location_id = location_info["location_id"]
        @account_id = location_info["account_id"]
        @latitude = location_info["latitude"]
        @longitude = location_info["longitude"]
        @cur_address = location_info["cur_address"]
        @cur_name = location_info["cur_name"]
        @created_at = location_info["created_at"]
      end
  
      attr_reader :location_info, :location_id, :account_id, :latitude, :longitude, :cur_address, :cur_name, :created_at
  
    end
  end
  