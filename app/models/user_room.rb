# frozen_string_literal: true

module Cryal
  # Behaviors of the room
  class UserRoom
    def initialize(room_info)
      @room_info = room_info
      @room_serial = room_info["id"]
      @room_id = room_info["room_id"]
      @account_id = room_info["account_id"]
      @active = room_info["active"]
      @authority = room_info["authority"]
    end

    attr_reader :room_info, :room_serial, :room_id, :account_id, :active, :authority

    def member?
      @authority == "member"
    end

    def admin?
      @authority == "admin"
    end

  end
end
