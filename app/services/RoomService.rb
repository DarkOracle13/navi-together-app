require 'http'

module Cryal
    class RoomService
        class UnauthorizedError < StandardError; end

        def initialize(config)
            @config = config
        end

        def create(routing, current_account)
            account_id = current_account['account_id']
            puts account_id
            response = HTTP.post("http://localhost:3000/api/v1/accounts/#{account_id}/createroom",
                            json: {room_name: routing.params['room_name'], room_description: routing.params['room_description'],
                                    room_password: routing.params['room_password']})

            raise(UnauthorizedError) unless response.code == 201

            body = JSON.parse(response.body)
            data = body['data'] if body['data']
            room_data = data

            # because create room, must continue to join the room
            room_id = room_data['room_id']
            response_join_room = HTTP.post("http://localhost:3000/api/v1/accounts/#{account_id}/joinroom",
                                  json: {room_id: room_id , room_password: routing.params['room_password'],
                                  active: true, authority: 'admin'})

            raise(UnauthorizedError) unless response.code == 201

            room_data
        end

        def join(routing, current_account)
            account_id = current_account['account_id']
            response = HTTP.post("http://localhost:3000/api/v1/accounts/#{account_id}/joinroom",
                                  json: {room_id: routing.params['room_id'] , room_password: routing.params['room_password'],
                                  active: true, authority: 'member'})

            raise(UnauthorizedError) unless response.code == 201

            body = JSON.parse(response.body)
            data = body['data'] if body['data']
            data
        end
    end
end