# frozen_string_literal: true

require 'faraday'

module Sgas
  module Middleware
    class Proxy
      attr_reader :app, :options

      attr_accessor :caller, :request
      ##
      # @param  [#call]  app
      def initialize(app)
        @app = app
        @options = options
        @caller = Faraday.new(url: Sgas::Middleware.config.uri || 'http://localhost:8081/')
      end

      ##
      # @param  [Hash{String => String}] env
      # @return [Array(Integer, Hash, #each)]
      # @see    http://rack.rubyforge.org/doc/SPEC.html
      def call(env)
        @request = ActionDispatch::Request.new(env)
        return app.call(env) unless need_protection?

        res = session_check
        return login_path if res.nil?

        case res.status
        when 200
          status, headers, body = app.call(env)

          response = Rack::Response.new(body, status, headers)
          response.set_cookie('T_SID', value: JSON.parse(res.body)['auth_token'], path: '/', expires: Time.now.utc + 2.minutes)
          return response.finish
        when 204
          app.call(env)
        when 401
          return login_path
        else
          puts 'Keskispass'
        end
      end

      def need_protection?
        !@request.original_fullpath.start_with?('/rails', '/robots')
      end

      def session_check
        return nil unless token

        caller.post do |req|
          req.url '/auth'
          req.headers['Content-Type'] = 'application/json'
          req.body = { auth_token: token }.to_json
        end
      end

      private

      ##
      # @return [String]
      def token
        @request.cookies['T_SID']
      end

      ##
      # @return [Array]
      def login_path
        raise "Missing 'login_path' configuration. Please add to config/initializers/sgas.rb" unless Sgas::Middleware.config.login_path
        [301, { 'Location' => Sgas::Middleware.config.login_path, 'Content-Type' => 'text/html', 'Content-Length' => '0' }, []]
      end

      ##
      # @param  [Rack::Request] request
      # @return [String]
      def client_identifier(request)
        request.ip.to_s
      end

      ##
      # @param  [Rack::Request] request
      # @return [Float]
      def request_start_time(request)
        # Check whether HTTP_X_REQUEST_START or HTTP_X_QUEUE_START exist and parse its value (for
        # example, when having nginx in your stack, it's going to be in the "t=\d+" format).
        if val = (request.env['HTTP_X_REQUEST_START'] || request.env['HTTP_X_QUEUE_START'])
          val[/(?:^t=)?(\d+)/, 1].to_f / 1000
        else
          Time.now.to_f
        end
      end
    end
  end
end
