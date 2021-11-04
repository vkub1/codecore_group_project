class AddRequestTypeToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :request_type, :string
  end
end
