class TripsController < ApplicationController
  include SessionsHelper

  before_action :logged_in_user, only: [:index, :show]

  def index
    @trips = Trip.paginate(page: page_params[:page], per_page: 10)
  end

  def show
    @trip = Trip.find(require_id)
  end

  private
  def require_id
    params.require(:id)
  end

  def page_params
    params.permit(:page)
  end

  # Confirms a logged-in user.
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = 'Unauthorized'
      redirect_to login_url
    end
  end
end
