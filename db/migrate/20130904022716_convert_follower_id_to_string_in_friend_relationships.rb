class ConvertFollowerIdToStringInFriendRelationships < ActiveRecord::Migration
  def change
    remove_column :friend_relationships, :follower_id
    add_column :friend_relationships, :follower_id, :string
  end
end
