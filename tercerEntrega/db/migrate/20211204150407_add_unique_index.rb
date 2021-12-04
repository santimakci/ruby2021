class AddUniqueIndex < ActiveRecord::Migration[6.1]
  def change
    add_index :appointments, [:professional_id, :date, :hour], :unique => true
    add_index :appointments, [:user_id, :date, :hour], :unique => true
  end
end
