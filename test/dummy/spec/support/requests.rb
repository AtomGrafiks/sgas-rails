# frozen_string_literal: true
require 'json'
require 'net/http'

module Requests
  module JsonHelpers
    mattr_accessor :token

    def json
      JSON.parse(response.body)
    end

    def token
      @token ||= jwt_token
    end

    def jwt_token
      header = {'Content-Type': 'text/json'}
      user = { email: "test@atom.dev", password: "123456" }

      # Create the HTTP objects
      uri = URI.parse('http://localhost:8081/auth/new')
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.body = user.to_json

      # Send the request
      response = http.request(request)
      JSON.parse(response.body)['auth_token']
    end
  end
end
