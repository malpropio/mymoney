class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:create, :new, :destroy]
  ALLOWED = USERS_CONFIG["allowed_users"].split(',')

  def new
  end

  def create
    user = User.find_by(username: params[:session][:username].downcase)
    if user && ALLOWED.include?(user.email)
      if user.authenticate(params[:session][:password])
        log_in user
	params[:session][:remember_me] == '1' ? remember(user) : forget(user)
	redirect_back_or root_url
      else
	  flash.now[:danger] = "Invalid username/password combination"
	  render 'new'
      end
    else
          flash.now[:danger] = "Invalid username or not Allowed to login"
          render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
