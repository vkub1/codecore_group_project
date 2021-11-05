class AddUserReferencesToFacilities < ActiveRecord::Migration[6.1]
  def change
    add_reference :facilities, :user, null: false, foreign_key: true
  end
end
