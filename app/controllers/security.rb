# frozen_string_literal: true

require_relative './app'
require 'roda'

require 'rack/ssl-enforcer'
require 'secure_headers'

module Cryal
  # Configuration for the API
  class App < Roda
    plugin :environments
    plugin :multi_route

    FONT_SRC = %w['self'
                  https://fonts.gstatic.com 
                  https://cdn.jsdelivr.net
                  https://maxcdn.bootstrapcdn.com
                  ].freeze
    
    SCRIPT_SRC = %w['self'
                    https://cdn.jsdelivr.net
                    https://unpkg.com 
                    https://cdnjs.cloudflare.com
                    ].freeze

    STYLE_SRC = %w['self'
                  https://bootswatch.com
                  https://cdn.jsdelivr.net
                  https://cdnjs.cloudflare.com 
                  https://unpkg.com 
                  https://fonts.gstatic.com
                  https://fonts.googleapis.com 
                  https://maxcdn.bootstrapcdn.com
                  ].freeze
    
    IMG_SRC = %w['self' data:
                  https://a.tile.openstreetmap.org
                  https://b.tile.openstreetmap.org
                  https://c.tile.openstreetmap.org
                  https://unpkg.com/leaflet@1.9.4/dist/images
                  https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png
                  https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-2x.png
                  https://unpkg.com/leaflet@1.9.4/dist/images/marker-shadow.png
                  https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-blue.png
                  https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon-red.png
                 ].freeze

    CNT_SRC = %w['self'
                https://cdnjs.cloudflare.com
                https://nominatim.openstreetmap.org
                ].freeze
    
    
    configure :production do
      use Rack::SslEnforcer, hsts: true
    end

    ## Uncomment to drop the login session in case of any violation
    # use Rack::Protection, reaction: :drop_session
    use SecureHeaders::Middleware

    SecureHeaders::Configuration.default do |config|
      config.cookies = {
        secure: true,
        httponly: true,
        samesite: {
          lax: true
        }
      }

      config.x_frame_options = 'DENY'
      config.x_content_type_options = 'nosniff'
      config.x_xss_protection = '1'
      config.x_permitted_cross_domain_policies = 'none'
      config.referrer_policy = 'origin-when-cross-origin'

      # note: single-quotes needed around 'self' and 'none' in CSPs
      # rubocop:disable Lint/PercentStringArray
        config.csp = {
            report_only: false,
            preserve_schemes: true,
            default_src: %w['self'],
            child_src: %w['self'],
            connect_src: %w[wws:] + CNT_SRC,
            img_src: %w['self'] + IMG_SRC,
            font_src: %w['self'] + FONT_SRC,
            script_src: %w['self'] + SCRIPT_SRC,
            style_src: %w['self'] + STYLE_SRC,
            form_action: %w['self'],
            frame_ancestors: %w['none'],
            object_src: %w['none'],
            block_all_mixed_content: true,
            report_uri: %w[/security/report_csp_violation]
        }
      # rubocop:enable Lint/PercentStringArray
    end

    route('security') do |routing|
      # POST security/report_csp_violation
      routing.post 'report_csp_violation' do
        puts "CSP VIOLATION WOI: #{request.body.read}"
        App.logger.warn "CSP VIOLATION: #{request.body.read}"
      end
    end
  end
end