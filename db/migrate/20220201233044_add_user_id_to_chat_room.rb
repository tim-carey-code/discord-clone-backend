class AddUserIdToChatRoom < ActiveRecord::Migration[6.1]
  def change
    add_column :chatrooms, :user_id, :integer
  end
end
