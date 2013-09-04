class AddIsNewToFriendRelationships < ActiveRecord::Migration
  def change
    add_column :friend_relationships, :is_new, :boolean, default: true
  end
end
