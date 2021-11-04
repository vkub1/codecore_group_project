class AddCourseIdToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :course_id, :bigint
  end
end
