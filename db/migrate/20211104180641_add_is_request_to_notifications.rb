class AddIsRequestToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :is_request, :boolean, default: false
  end
end
