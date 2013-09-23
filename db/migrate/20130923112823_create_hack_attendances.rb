class CreateHackAttendances < ActiveRecord::Migration
  def change
    create_table :hack_attendances do |t|
      t.references :hack_meet, index: true
      t.references :hack_member, index: true

      t.timestamps
    end
  end
end
