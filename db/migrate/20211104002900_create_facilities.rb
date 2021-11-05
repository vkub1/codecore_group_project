class CreateFacilities < ActiveRecord::Migration[6.1]
  def change
    create_table :facilities do |t|
      t.string :full_address
      t.text :features

      t.timestamps
    end
  end
end
