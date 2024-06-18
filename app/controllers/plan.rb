# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('plan') do |routing|
        routing.on String do |room_id|
          routing.on String do |plan_name|
            # GET plan/:room_id/:plan_name
              routing.get do
                  output = Cryal::PlanService.new(App.config).get_plans(routing, @current_account, plan_name, room_id)
                  @plans = Cryal::Plan.new(output["plan"], room_id)
                  @waypoints = output["waypoints"].map{|waypoint| Cryal::Waypoint.new(waypoint)}
                  @user_data = output['user_locations']
                  view :plan_page, locals: { current_account: @current_account }
              end

              routing.delete do
                  output = Cryal::PlanService.new(App.config).delete_plan(routing, @current_account, room_id, plan_name)
                  flash[:notice] = "Plan Deleted Successfully"
              end

            # POST plan/:room_id/:plan_name - Create a waypoint for this plan.
            routing.on 'waypoints' do
              routing.is do
                routing.post do
                    output = Cryal::PlanService.new(App.config).create_waypoint(routing, @current_account, room_id)
                    puts "waypoint created successfully #{output['waypoint_name']}"
                    flash[:notice] = "Waypoint Created Successfully #{output['waypoint_name']}"
                    routing.redirect "/plan/#{room_id}/#{plan_name}"
                rescue StandardError
                    puts "failed to create waypoint"
                    flash.now[:error] = "Failed to Create Waypoint"
                    response.status = 400
                    view :plan_page, locals: { current_account: @current_account }
                end

              # DELETE plan/:room_id/:plan_name - Delete a waypoint for this plan.
                routing.delete do
                    output = Cryal::PlanService.new(App.config).delete_waypoint(routing, @current_account, room_id)
                    flash[:notice] = "Waypoint Deleted Successfully"
                    # view :plan_page, locals: { current_account: @current_account }
                rescue StandardError
                    flash.now[:error] = "Failed to Delete Waypoint"
                    response.status = 400
                    view :plan_page, locals: { current_account: @current_account }
                end
              end
            end
          end
        end
    end
  end
end
