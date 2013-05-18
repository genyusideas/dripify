class AddCampaignToDripMarketingRules < ActiveRecord::Migration
  def change
    add_column :drip_marketing_rules, :drip_marketing_campaign_id, :integer
    add_index :drip_marketing_rules, :drip_marketing_campaign_id
  end
end
