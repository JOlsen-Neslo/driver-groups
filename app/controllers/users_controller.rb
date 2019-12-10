class UsersController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :find_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def show
    @user = User.find(require_id)
  end

  def edit
    @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:info] = 'User has been successfully registered!'
      redirect_to root_url
    else
      flash[:error] = 'Failed to register the user!'
      render 'new'
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Updated profile successfully!'
      redirect_to @user
    else
      flash[:error] = 'Failed to update your profile!'
      render 'edit'
    end
  end

  private

  def user_params
    params
        .require(:user)
        .permit(
            :username,
            :password,
            :password_confirmation,
            person_attributes: [:date_of_birth, name_attributes: [:value]]
        )
  end

  def require_id
    params.require(:id)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Unauthorized'
      redirect_to login_url
    end
  end

  # Confirms the correct user.
  def correct_user
    @user = User.find(require_id)
    redirect_to(root_url) unless current_user?(@user)
  end

  def find_user
    @user = User.find(require_id)
    return true unless @user.nil?
    flash[:error] = 'Cannot find the user'
    false
  end
end
