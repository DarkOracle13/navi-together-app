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

    end
end