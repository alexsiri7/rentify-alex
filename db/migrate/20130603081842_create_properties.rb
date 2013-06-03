class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :name
      t.integer :number_of_rooms
      t.float :latitude
      t.float :longitude
      t.boolean :is_available

      t.timestamps
    end
  end
end
