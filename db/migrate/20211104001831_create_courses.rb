class CreateCourses < ActiveRecord::Migration[6.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.text :description
      t.integer :max_students
      t.boolean :full

      t.timestamps
    end
  end
end
