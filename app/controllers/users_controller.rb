class UsersController < ApplicationController
  respond_to :json

  # GET /users/:id
  def show
    render json: User.find( params[:id] )
  end
end
