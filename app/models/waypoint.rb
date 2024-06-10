# frozen_string_literal: true

module Cryal
    # Behaviors of the room
    class Waypoint
      def initialize(waypoint_info)
        @waypoint_info = waypoint_info
        @plan_id = waypoint_info["plan_id"]
        @waypoint_lat = waypoint_info["waypoint_lat"]
        @waypoint_long = waypoint_info["waypoint_long"]
        @waypoint_address = waypoint_info["waypoint_address"]
        @waypoint_name = waypoint_info["waypoint_name"]
        @waypoint_number = waypoint_info["waypoint_number"]
        @created_at = waypoint_info["created_at"]
        @updated_at = waypoint_info["updated_at"]
      end
  
      attr_reader :waypoint_info, :plan_id, :waypoint_lat, :waypoint_long, :waypoint_address, :waypoint_name, :waypoint_number, :created_at, :updated_at
  
    end
  end
  