require 'test_helper'

class Sgas::Rails::Middleware::Test < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Sgas::Rails::Middleware
  end
end
