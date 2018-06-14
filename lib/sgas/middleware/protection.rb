# frozen_string_literal: true

module Sgas
  module Middleware
    class Protection
      attr_reader :app

      ##
      # @param  [#call]  app
      def initialize(app)
        @app = app
      end

      ##
      # Check if action need a protection, by default an action is unprotected
      # If you don't need to protect, add the action to `protected_by_auth_server`
      # @param  [Hash{String => String}] env
      # @return [Array(Integer, Hash, #each)]
      # @see    http://rack.rubyforge.org/doc/SPEC.html
      def call(env)
        if Sgas::Routing::AuthHandler.find_by_path(env['PATH_INFO']).protected?
          Sgas::Middleware::Proxy.new(app).call(env)
        else
          app.call(env)
        end
      end
    end
  end
end
