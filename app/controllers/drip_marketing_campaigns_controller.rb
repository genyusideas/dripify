class DripMarketingCampaignsController < ApplicationController
  before_filter :find_owner
  respond_to :json

  # GET /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns/:id
  def show
    unless @owner.nil?
      begin
        render json: @owner.drip_marketing_campaigns.find( params[:id] )
      rescue
        render json: { error: "DripMarketingCampaign not found" }, status: 403
      end
    else
      render json: { error: "Twitter account not found" }, status: 403
    end
  end

  # GET /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns
  def index
    unless @owner.nil?
      begin
        render json: @owner.drip_marketing_campaigns
      rescue
        render json: { error: "DripMarketingCampaigns not found" }, status: 403
      end
    else
      render json: { error: "Twitter account not found" }, status: 403
    end
  end

  # POST /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns
  def create
    unless @owner.nil?
      @drip_marketing_campaign = @owner.drip_marketing_campaigns.build
      if @drip_marketing_campaign.save
        render json: @drip_marketing_campaign
      else
        render json: { error: "Error saving campaign" }, status: 500
      end
    else
      render json: { error: "Twitter account not found" }, status: 403
    end
  end

  private

  def find_owner
    user = User.find_by_id params[:user_id]
    unless user.nil?
      @owner = user.twitter_accounts.find_by_id params[:twitter_account_id]
    else
      nil
    end
  end
end
