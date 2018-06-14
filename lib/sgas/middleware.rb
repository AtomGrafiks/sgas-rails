# frozen_string_literal: true

require 'sgas/middleware/railtie'
require 'sgas/routing'

module Sgas
  module Middleware
    VERSION = '0.1.0'

    autoload :Proxy, 'sgas/middleware/proxy'
    autoload :Protection, 'sgas/middleware/protection'

    def self.configure
      @config ||= ::OpenStruct.new
      yield(@config) if block_given?
      @config
    end

    def self.config
      @config || configure
    end
  end
end
