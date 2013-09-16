class CreateTwitterMessages < ActiveRecord::Migration
  def change
    create_table :twitter_messages do |t|
      t.integer :twitter_account_id
      t.integer :recipient_id
      t.text :message
      t.string :status
      t.datetime :send_date

      t.timestamps
    end
  end
end
