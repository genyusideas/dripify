class UsersController < ApplicationController
  respond_to :json

  # GET /users/:id
  def show
    begin
      render json: User.find( params[:id] )
    rescue
      render json: { error: "User not found" }, status: 403
    end
  end
end
