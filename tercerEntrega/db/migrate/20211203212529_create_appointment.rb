class CreateAppointment < ActiveRecord::Migration[6.1]
  def change
    create_table :appointments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :professional, null: false, foreign_key: true
      t.date :date
      t.time :hour

      t.timestamps
    end
  end
end
