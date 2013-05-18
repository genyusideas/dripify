class CreateSocialMediaAccounts < ActiveRecord::Migration
  def change
    create_table :social_media_accounts do |t|
      t.string :type
      t.string :handle
      t.string :handle_id
      t.integer :user_id

      t.timestamps
    end

    add_index :social_media_accounts, :user_id
    add_index :social_media_accounts, :handle_id, unique: true
  end
end
