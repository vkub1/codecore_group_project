class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email, index: {unique: true}
      t.string :password_digest
      t.boolean :is_admin, null: false, default: false

      t.timestamps
    end
  end
end
