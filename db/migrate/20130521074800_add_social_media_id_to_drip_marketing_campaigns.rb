class AddSocialMediaIdToDripMarketingCampaigns < ActiveRecord::Migration
  def change
    add_column :drip_marketing_campaigns, :social_media_account_id, :integer
    add_index :drip_marketing_campaigns, :social_media_account_id
  end
end
