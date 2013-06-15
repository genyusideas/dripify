class AddFieldsToSocialMediaAccounts < ActiveRecord::Migration
  def change
    add_column :social_media_accounts, :token, :string
    add_column :social_media_accounts, :secret, :string
    add_column :social_media_accounts, :profile_image_url, :string
  end
end
