# # frozen_string_literal: true
# require 'active_support'

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
# module Sgas
#   module Controller
#     module ControllerAdditions
#       extend ActiveSupport::Concern

#       def included(klass)
#         klass.extend(ClassMethods)
#       end


#       module ClassMethods
#         def protected_by_auth_service(hash = {})
#           actions_to_protect = [hash[:only]].flatten if hash[:only].present?
#           # [self.action_methods.to_a.map(&:to_sym)]
#           # This method don't return defined actions
#           actions_to_protect ||= [:index, :show, :edit, :update, :new, :create, :destroy]
#           actions_to_protect -= ([hash[:except]].flatten || [])
          
#           ap actions_to_protect
#           actions_to_protect.each do |action|
#             ap [action, "#{action}_protected?"]
#             define_singleton_method("#{action}_protected?") {
#               ap [action, action.in?(actions_to_protect)]
#               action.in?(actions_to_protect) 
#             }
#           end
#         end
#       end
#     end
#   end
# end

# ActionController::Base.send(:include, Sgas::Controller::ControllerAdditions)
# ActionController::API.send(:include, Sgas::Controller::ControllerAdditions)

# Get routes
# Rails.application.routes.routes.reject{ |a| a.name.nil? or a.name&.start_with?("rails_") }
