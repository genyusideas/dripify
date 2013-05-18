class CreateDripMarketingRules < ActiveRecord::Migration
  def change
    create_table :drip_marketing_rules do |t|
      t.integer :delay
      t.text :message

      t.timestamps
    end
  end
end
