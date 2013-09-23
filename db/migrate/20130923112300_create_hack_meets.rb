class CreateHackMeets < ActiveRecord::Migration
  def change
    create_table :hack_meets do |t|
      t.integer :hack_year, :null => false
      t.integer :hack_month, :null => false
      t.date :hack_date, :null => false
      t.string :start_time, :null => false, :default => "8:00"
      t.string :work_area
      t.text :notes
      t.references :hack_venue, index: true, :null => false
      t.boolean :social, :default => false
      t.integer :hack_attendances_count, :default => 0

      t.timestamps
    end
  end
end
