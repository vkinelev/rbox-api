class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def app_status
    render json: { status: "i'm ok" }
  end
end
