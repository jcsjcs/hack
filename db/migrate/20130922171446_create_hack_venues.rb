class CreateHackVenues < ActiveRecord::Migration
  def change
    create_table :hack_venues do |t|
      t.string :venue, :null => false
      t.text :notes

      t.timestamps
    end
  end
end
