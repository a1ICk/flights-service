class CreateFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :flights do |t|
      t.string :flight_number
      t.float :distance, default: 0.0

      t.timestamps
    end
  end
end
