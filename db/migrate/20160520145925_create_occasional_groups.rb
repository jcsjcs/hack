class CreateOccasionalGroups < ActiveRecord::Migration
  def change
    create_table :occasional_groups do |t|
      t.string :description, :null => false
      t.integer :no_of_attendees, :null => false
      t.text :notes, :null => false
      t.references :hack_meet, index: true, :null => false

      t.timestamps
    end
  end
end
