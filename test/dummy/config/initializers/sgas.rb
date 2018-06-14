# frozen_string_literal: true

Sgas::Middleware.configure do |config|
  # Configure base URI of SGAS service
  config.base_uri   = 'http://localhost:8081/'
  config.login_path = '/login'
end
