# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('room') do |routing|
        routing.on 'view' do
          routing.on String do |room_id| #udah ada tapi harus ubah api
            routing.on 'plan' do
              routing.post do
                plan = Cryal::PlanService.new(App.config).create(routing, @current_account, room_id)
                puts "plan created successfully #{plan['plan_name']}"
                flash[:notice] = "Plan Created Successfully #{plan['plan_name']}"
                routing.redirect "/room/view/#{room_id}"
              rescue StandardError
                puts "failed to create plan"
                flash.now[:error] = "Failed to Create Plan"
                response.status = 400
                view :room_page, locals: { current_account: @current_account }
              end
            end

            routing.get do
              output = Cryal::RoomService.new(App.config).getroom(routing, @current_account, room_id)
              @mymember = output["accounts"].map { |account| Cryal::Account.new(account, nil) }
              @myplans = output["plans"].map { |plan| Cryal::Plan.new(plan, room_id) }
              @myrooms = Cryal::Room.new(output["rooms"])
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
            output = Cryal::RoomService.new(App.config).myroom(routing, @current_account)
            # @mymember = output["accounts"].map { |account| Cryal::Account.new(account, nil) }
            # @myplans = output["plans"].map { |plan| Cryal::Plan.new(plan, room_id) }
            room = output["all_rooms"].map { |room| Cryal::Room.new(room) }
            @myrooms = output["user_rooms"].map do |user_room|
              room_data = room.find { |room| room.room_id == user_room["room_id"] }
              puts "room_data: #{room_data.inspect}"
              puts "user_room: #{user_room.inspect}"
              Cryal::UserRoom.new(user_room, room_data)
            end
            view :myroom, locals: { current_account: @current_account}
          end
        end
    end
  end
end
