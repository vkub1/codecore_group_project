class CreateBookings < ActiveRecord::Migration[6.1]
  def change
    create_table :bookings do |t|
      t.references :facility, null: false, foreign_key: true
      t.references :course, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :end_time, null: false

      t.timestamps
    end
  end
end
