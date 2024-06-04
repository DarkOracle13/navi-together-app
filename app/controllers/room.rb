# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('room') do |routing|
        routing.on 'view' do
          routing.on String do |room_id|
            routing.get do
              view :createroom, locals: { current_account: @current_account }
            end


            routing.post do
              # room = Cryal::RoomService.new(App.config).create(routing, @current_account)
              # flash[:notice] = "Room Created Successfully #{room['room_name']}"
              routing.redirect '/'
            rescue StandardError
              flash.now[:error] = "Something Wrong"
              response.status = 400
              view :myroom, locals: { current_account: @current_account}
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
          @myrooms = room
          view :myroom, locals: { current_account: @current_account}
        end
      end
    end
  end
end
