# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('room') do |routing|
        routing.on 'view' do
          routing.on String do |room_id| #udah ada tapi harus ubah api
            routing.get do
              # puts room_id
              output = Cryal::RoomService.new(App.config).getroom(routing, @current_account, room_id)
              @mymember = output["accounts"].map { |account| Cryal::Account.new(account, nil) }
              @myplans = output["plans"].map { |plan| Cryal::Plan.new(plan, room_id) }
              puts @myplans
              @myrooms = Cryal::Room.new(output["rooms"])
              # puts room
              view :room_page, locals: { current_account: @current_account}
            end
          end
        end

        routing.on 'create' do
          routing.get do
            view :createroom, locals: { current_account: @current_account }
          end
          # POST /room/create
          routing.post do
            room = Cryal::RoomService.new(App.config).create(routing, @current_account)
            flash[:notice] = "Room Created Successfully #{room['room_name']}"
            routing.redirect '/'
          rescue StandardError
            flash.now[:error] = "Failed to Create Room"
            response.status = 400
            view :createroom
          end
        end

        routing.on 'join' do
          routing.get do
            view :joinroom
          end

          # POST /room/join
          routing.post do
            room = Cryal::RoomService.new(App.config).join(routing, @current_account)
            flash[:notice] = "Room Joined Successfully #{room['room_name']}"
            routing.redirect '/'
          rescue StandardError
            flash.now[:error] = "Failed to Join Room(already joined or failed)"
            response.status = 400
            view :joinroom
          end
        end

        routing.on 'myroom' do
          routing.get do
            room = Cryal::RoomService.new(App.config).myroom(routing, @current_account)
            @myrooms = room.map { |room| Cryal::UserRoom.new(room) }
            
            view :myroom, locals: { current_account: @current_account}
          end
        end
    end
  end
end
