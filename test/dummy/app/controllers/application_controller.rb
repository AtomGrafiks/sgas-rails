class ApplicationController < ActionController::API
  def login
    render json: {error: "You need to login"}
  end

  def home
    render json: {success: "Welcome !"}
  end
end
