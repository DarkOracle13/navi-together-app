# frozen_string_literal: true

module Cryal
  # Behaviors of the room
  class Room
    def initialize(room_info)
      @room_info = room_info
      @room_id = room_info["room_id"]
      @room_description = room_info["room_description"]
      @created_at = room_info["created_at"]
      @updated_at = room_info["updated_at"]
    end

    attr_reader :room_info, :room_id, :room_description, :created_at, :updated_at

  end
end
