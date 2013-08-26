class DripMarketingRulesController < ApplicationController
  before_filter :find_owner
  respond_to :json

  # GET /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns/:drip_marketing_campaign_id/drip_marketing_rules
  def index
    unless @owner.nil?
      begin
        render json: @owner.drip_marketing_rules
      rescue
        render json: Array.new
      end
    else
      render json: { error: "User not found" }, status: 403
    end
  end

  # GET /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns/:drip_marketing_campaign_id/drip_marketing_rules
  def create
    unless @owner.nil?
      @drip_marketing_rule= @owner.drip_marketing_rules.build( params[:drip_marketing_rule] )
      if @drip_marketing_rule.save
        render json: @drip_marketing_rule
      else
        render json: { error: "Error saving account" }, status: 500
      end
    else
      render json: { error: "User not found" }, status: 403
    end
  end

  # PUT /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns/:drip_marketing_campaign_id/drip_marketing_rules/:id
  def update
    unless @owner.nil?
      @drip_marketing_rule = @owner.drip_marketing_rules.find( params[:id] )
      unless @drip_marketing_rule.nil?
        if @drip_marketing_rule.update_attributes params[:drip_marketing_rule]
          render json: @drip_marketing_rule
        else
          render json: { error: "Error updating the rule" }, status: 500
        end
      else
        render json: { error: "Rule not found" }, status: 403
      end
    else
      render json: { error: "User not found" }, status: 403
    end
  end
  
  # DELETE /users/:user_id/twitter_accounts/:twitter_account_id/drip_marketing_campaigns/:drip_marketing_campaign_id/drip_marketing_rules/:id
  def destroy
    unless @owner.nil?
      @drip_marketing_rule = @owner.drip_marketing_rules.find( params[:id] )
      unless @drip_marketing_rule.nil?
        if @drip_marketing_rule.destroy
          render json: @drip_marketing_rule, status: 200
        else
          render json: { error: "Error deleting rule" }, status: 500
        end
      else
        render json: { error: "Rule not found" }, status: 403
      end
    else
      render json: { error: "User not found" }, status: 403 
    end
  end

  private

  def find_owner
    user = User.find_by_id params[:user_id]
    unless user.nil?
      twitter = user.twitter_accounts.find_by_id params[:twitter_account_id]
      unless twitter.nil?
        @owner = twitter.drip_marketing_campaigns.find_by_id params[:drip_marketing_campaign_id]
      else
        @owner = nil
      end
    else
      @owner = nil
    end
  end
end
