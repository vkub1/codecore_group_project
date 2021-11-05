class AddEnrollmentIdToNotificationos < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :enrollment_id, :bigint
  end
end
