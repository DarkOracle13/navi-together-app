# frozen_string_literal: true

module Cryal
  # Behaviors of the room
  class Plan
    def initialize(plan_info, room_id)
      @plan_info = plan_info
      @room_id = room_id
      @plan_id = plan_info['plan_id']
      @plan_name = plan_info['plan_name']
      @plan_description = plan_info['plan_description']
      @created_at = plan_info['created_at']
      @updated_at = plan_info['updated_at']
    end

    attr_reader :plan_info, :room_id, :plan_id, :plan_name, :plan_description, :created_at, :updated_at
  end
end
