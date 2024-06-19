# frozen_string_literal: true

require 'http'

module Cryal
  # Plan Service
  class PlanService
    class PlanSystemError < StandardError; end
    class CurrentPlanError < StandardError; end

    def initialize(config)
      @config = config
    end

    # /api/v1/rooms/room_id/plans?plan_name="some_plan_name"
    def get_plans(_routing, current_account, plan_name, room_id)
      # puts current_account.auth_token
      plan_name = plan_name.gsub('%20', ' ')
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.get("#{@config.API_URL}/rooms/#{room_id}/plans?plan_name=#{plan_name}", headers:)
      puts JSON.parse(response.body)
      puts response.code
      raise(PlanSystemError) unless response.code == 200

      body = JSON.parse(response.body)
      data = body['data'] if body['data']
      # puts "The data is #{data}"
      data
    end

    def delete_plan(_routing, current_account, room_id, plan_name)
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      response = HTTP.delete("#{@config.API_URL}/rooms/#{room_id}/plans?plan_name=#{plan_name}", headers:)
      raise(PlanSystemError) unless response.code == 200

      JSON.parse(response.body)
    end

    def create(routing, current_account, room_id)
      plan_name = routing.params['plan_name']
      plan_description = routing.params['plan_description']
      package = { plan_name:, plan_description: }
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      post_string = "#{@config.API_URL}/rooms/#{room_id}/plans"

      # Convert the package to JSON string
      response = HTTP.post(post_string, headers:, body: package.to_json)
      # puts "response body: #{response.body}"

      raise(PlanSystemError) unless response.code == 201

      JSON.parse(response.body)
    end

    def create_waypoint(request, current_account, room_id) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
      waypoint_data = JSON.parse(request.body.read) # Read and parse JSON data from request body
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      package = { plan_id: waypoint_data['plan_id'],
                  latitude: waypoint_data['latitude'],
                  longitude: waypoint_data['longitude'],
                  waypoint_address: waypoint_data['waypoint_address'],
                  waypoint_name: waypoint_data['waypoint_name'] }
      post_string = "#{@config.API_URL}/rooms/#{room_id}/plans/#{waypoint_data['plan_id']}/waypoints"
      response = HTTP.post(post_string, headers:, body: package.to_json)
      raise(PlanSystemError) unless response.code == 201

      JSON.parse(response.body)
    end

    def delete_waypoint(request, current_account, room_id)
      waypoint_id = request.params['waypoint_id']
      plan_id = request.params['plan_id'] # Ensure plan_id is properly set here
      headers = { 'Authorization' => "Bearer #{current_account.auth_token}",
                  'Content-Type' => 'application/json' }
      delete_string = "#{@config.API_URL}/rooms/#{room_id}/plans/#{plan_id}/waypoints?waypoint_id=#{waypoint_id}"
      response = HTTP.delete(delete_string, headers:)
      raise PlanSystemError, "Failed to delete waypoint: #{response.body}" unless response.code == 200

      JSON.parse(response.body)
    end
  end
end
