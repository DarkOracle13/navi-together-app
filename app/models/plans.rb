# frozen_string_literal: true

module Cryal
    # Behaviors of the room
    class Location
      def initialize(plan_info)
        @plan_info = plan_info
        @plan_id = plan_info["plan_id"]
        @room_id = plan_info["room_id"]
        @plan_name = plan_info["plan_name"]
        @plan_description = plan_info["plan_description"]
        @cur_name = plan_info["cur_name"]
        @created_at = plan_info["created_at"]
      end
  
      attr_reader :plan_info, :location_id, :latitude, :longitude, :cur_address, :cur_name, :created_at
  
    end
  end
  