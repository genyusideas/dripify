class UsersController < ApplicationController
  respond_to :json
  before_filter :authenticate_user!, only: [:show, :get_current_user]

  # GET /users/:id
  def show
    begin
      render json: User.find( params[:id] )
    rescue
      render json: { error: "User not found" }, status: 403
    end
  end

  # GET /users/get_current_user
  def get_current_user
    if current_user
      render json: current_user
    else
      render json: { error: "You must be logged in." }, status: 401
    end
  end
end
