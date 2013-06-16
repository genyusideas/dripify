class OmniauthorizeController < ApplicationController
  respond_to :json

  def create
    if current_user
      uid = env["omniauth.auth"]["uid"]
      handle = env["omniauth.auth"]["info"]["nickname"]
      profile_image_url = env["omniauth.auth"]["info"]["image"]
      token = env["omniauth.auth"]["credentials"]["token"]
      secret = env["omniauth.auth"]["credentials"]["secret"] 
      twitter_account = TwitterAccount.find_by_handle_id uid
      unless twitter_account.nil?
        if twitter_account.user.id == current_user.id
          if twitter_account.update_attributes(
            profile_image_url:  profile_image_url,
            token:              token,
            secret:             secret
          )
            render inline: "<script>window.close();</script>"
          else
            render inline: "Error updating your Twitter account"
          end
        else
          render inline: "Error: account registered with another user."
        end
      else
        twitter_account = TwitterAccount.new(
          handle_id:          uid,
          handle:             handle,
          profile_image_url:  profile_image_url,
          token:              token,
          secret:             secret
        )
        twitter_account.user = current_user
        if twitter_account.save
          render inline: "<script>window.close();</script>"
        else
          render inline: "Error creating your Twitter account"
        end
      end
    else
      render inline: "Error: you must be logged in to Dripp.io."
    end
  end
end