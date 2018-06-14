# frozen_string_literal: true

module Sgas
  module Routing
    class AuthHandler
      attr_reader :controller, :action, :params, :opts

      def initialize(hash)
        @controller = hash[:controller]
        @action     = hash[:action]
        @protect    = !hash[:auth].nil?
        @opts       = hash[:auth].is_a?(Hash) ? hash[:auth] : nil
      end

      def protected?
        !!@protect
      end

      def self.find_by_path(path_info)
        new(Rails.application.routes.recognize_path(path_info))
      rescue ActionController::RoutingError
        nil
      end
    end
  end
end
