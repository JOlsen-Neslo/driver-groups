class SessionsController < ApplicationController
  include SessionsHelper

  def new
  end

  def create
    user = User.find_by(username: session_params[:username]&.downcase)
    if authenticate? user
      login_in_and_redirect(user)
    else
      flash.now[:danger] = 'Credentials supplied could not be matched to an account'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end

  def authenticate?(user)
    user && user.authenticate(session_params[:password])
  end

  def login_in_and_redirect(user)
    log_in user
    redirect_back_or user
  end
end
