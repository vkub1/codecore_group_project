class CreateEnrollments < ActiveRecord::Migration[6.1]
  def change
    create_table :enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.boolean :is_teacher, default: false

      t.timestamps
    end
  end
end
