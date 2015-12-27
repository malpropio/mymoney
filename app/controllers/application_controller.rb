class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  include ApplicationHelper

  before_action :require_login

  def authorize(object=nil)
    if object.user != current_user
      flash[:error] = "You dont have permission to access this section"
      redirect_to root_url
    end
  end

  private

  def require_login
    unless logged_in?
      store_location
      flash[:error] = "You must be logged in to access this section"
      redirect_to login_url 
    end
  end
end
