class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.text :message
      t.boolean :accepted
      t.boolean :read, default: false
      t.references :sender, null: false, foreign_key: { to_table: 'users' }
      t.references :receiver, null: false, foreign_key: { to_table: 'users' }
      t.timestamps
    end
    
  end
end
