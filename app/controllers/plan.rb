# frozen_string_literal: true

require 'roda'
require_relative './app'

module Cryal
  # Base class for Credence Web Application
  class App < Roda
    route('plan') do |routing|
        routing.on String do |room_id|
          routing.on String do |plan_name|
              routing.get do
                  output = Cryal::PlanService.new(App.config).get_plans(routing, @current_account, plan_name, room_id)
                  @plans = Cryal::Plan.new(output["plan"], room_id)
                  @waypoints = output["waypoints"].map{|waypoint| Cryal::Waypoint.new(waypoint)}
                  @user_data = output['user_locations']
                  view :plan_page, locals: { current_account: @current_account }
              end
          end
        end
    end
  end
end
