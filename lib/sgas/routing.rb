# frozen_string_literal: true

module Sgas
  module Routing
    autoload :AuthHandler, 'sgas/routing/auth_handler'

    def self.rails_routes
      @rails_routes ||= Rails.application.routes.routes.select{ |a| a.name&.start_with?("rails_") }
    end

    def self.app_routes
      @app_routes ||= Rails.application.routes.routes.reject{ |a| a.name.nil? or a.name&.start_with?("rails_") }
    end
  end
end