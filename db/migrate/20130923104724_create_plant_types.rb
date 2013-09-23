class CreatePlantTypes < ActiveRecord::Migration
  def change
    create_table :plant_types do |t|
      t.string :name, :null => false
      t.text :notes

      t.timestamps
    end
  end
end
