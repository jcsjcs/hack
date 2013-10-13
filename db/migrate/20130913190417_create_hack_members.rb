class CreateHackMembers < ActiveRecord::Migration
  def change
    create_table :hack_members do |t|
      t.string :title
      t.string :initials
      t.string :first_name
      t.string :surname, :null => false
      t.string :tel_home
      t.string :tel_office
      t.string :tel_cell
      t.string :email
      t.boolean :email_ok, :default => true
      t.string :email_issues
      t.boolean :non_hacker, :default => false
      t.text :comments
      t.integer :contact_via
      t.integer :group_with
      t.integer :hack_attendances_count, :default => 0

      t.timestamps
    end
  end
end
