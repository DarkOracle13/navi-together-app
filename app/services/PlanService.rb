require 'http'

module Cryal
    class PlanService
        class PlanSystemError < StandardError; end
        class CurrentPlanError < StandardError; end
        
        def initialize(config)
            @config = config
        end
        # /api/v1/rooms/room_id/plans?plan_name="some_plan_name"
        def get_plans(routing, current_account, plan_name, room_id)
            # puts current_account.auth_token
            plan_name = plan_name.gsub('%20', ' ')
            headers = { 'Authorization' => "Bearer #{current_account.auth_token}", 'Content-Type' => 'application/json' }
            response = HTTP.get("#{@config.API_URL}/rooms/#{room_id}/plans?plan_name=#{plan_name}", headers: )
            # puts JSON.parse(response.body)
            # puts response.code
            raise(PlanSystemError) unless response.code == 200
            body = JSON.parse(response.body)
            data = body['data'] if body['data']
            puts "The data is #{data}"
            data
        end

        def create(routing, current_account, room_id)
            plan_name = routing.params['plan_name']
            plan_description = routing.params['plan_description']
            package = { plan_name: plan_name, plan_description: plan_description }
            headers = { 'Authorization' => "Bearer #{current_account.auth_token}", 'Content-Type' => 'application/json' }
            post_string = "#{@config.API_URL}/rooms/#{room_id}/plans"
        
            # Convert the package to JSON string
            response = HTTP.post(post_string, headers: headers, body: package.to_json)
            puts "response body: #{response.body}"
            raise(PlanSystemError) unless response.code == 201
            
            JSON.parse(response.body)
        end        
    end
end