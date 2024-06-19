# frozen_string_literal: true

require 'http'

module Cryal
  # Room Service
  class RoomService
    class RoomSystemError < StandardError; end
    class MyRoomError < StandardError; end
    class GetRoom < StandardError; end

    def initialize(config)
      @config = config
    end

    def getroom(_routing, current_account, room_id)
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.get("#{@config.API_URL}/rooms?room_id=#{room_id}", headers:)
      raise(MyRoomError) unless response.code == 200

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      data
    end

    def myroom(_routing, current_account)
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.get("#{@config.API_URL}/rooms", headers:)
      raise(MyRoomError) unless response.code == 200

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      data
      # all_rooms = data['all_rooms']
      # user_rooms = data['user_rooms']
    end

    def create(routing, current_account) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      # /api/v1/rooms/createroom
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.post("#{@config.API_URL}/rooms/createroom",
                           json: { room_name: routing.params['room_name'],
                                   room_description: routing.params['room_description'],
                                   room_password: routing.params['room_password'] }, headers:)

      raise(RoomSystemError) unless response.code == 201

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      room_data = data

      # because create room, must continue to join the room
      room_id = room_data['room_id']
      HTTP.post("#{@config.API_URL}/rooms/joinroom",
                json: { room_id:, room_password: routing.params['room_password'],
                        active: true, authority: 'admin' }, headers:)

      raise(RoomSystemError) unless response.code == 201

      room_data
    end

    def join(routing, current_account)
      # /api/v1/rooms/joinroom
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.post("#{@config.API_URL}/rooms/joinroom",
                           json: { room_id: routing.params['room_id'], room_password: routing.params['room_password'],
                                   active: true, authority: 'member' }, headers:)

      raise(RoomSystemError) unless response.code == 201

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      data
    end

    def leave(_routing, current_account, room_id)
      # /api/v1/rooms/leaveroom
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.delete("#{@config.API_URL}/rooms/exit?room_id=#{room_id}", headers:)
      raise(RoomSystemError) unless response.code == 200

      JSON.parse(response.body)
    end

    def delete(_routing, current_account, room_id)
      # /api/v1/rooms/delete
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.delete("#{@config.API_URL}/rooms/delete?room_id=#{room_id}", headers:)
      raise(RoomSystemError) unless response.code == 200

      JSON.parse(response.body)
    end
  end
end
