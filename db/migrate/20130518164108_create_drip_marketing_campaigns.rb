class CreateDripMarketingCampaigns < ActiveRecord::Migration
  def change
    create_table :drip_marketing_campaigns do |t|
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
