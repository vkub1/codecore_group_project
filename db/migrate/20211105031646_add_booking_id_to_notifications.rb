class AddBookingIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :booking_id, :bigint
  end
end
