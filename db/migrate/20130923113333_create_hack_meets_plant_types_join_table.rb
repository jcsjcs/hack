class CreateHackMeetsPlantTypesJoinTable < ActiveRecord::Migration
  def change
    create_join_table :hack_meets, :plant_types do |t|
      # t.index [:hack_meet_id, :plant_type_id]
      t.index [:plant_type_id, :hack_meet_id], unique: true
    end
  end
end
