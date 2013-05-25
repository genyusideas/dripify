class TwitterAccountsController < ApplicationController
  before_filter :find_owner
  respond_to :json

  # GET /users/:user_id/twitter_accounts
  def index
    unless @owner.nil?
      begin
        render json: @owner.twitter_accounts
      rescue
        render json: Array.new
      end
    else
      render json: { error: "User not found" }, status: 403
    end
  end

  # GET /users/:user_id/twitter_accounts/:id
  def show
    unless @owner.nil?
      begin
        render json: @owner.twitter_accounts.find( params[:id] )
      rescue
        render json: { error: "Twitter account not found" }, status: 403
      end
    else
      render json: { error: "User not found" }, status: 403
    end
  end

  private

    def find_owner
      @owner = User.find_by_id params[:user_id]
    end
end
