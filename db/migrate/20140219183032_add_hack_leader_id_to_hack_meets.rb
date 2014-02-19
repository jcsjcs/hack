class AddHackLeaderIdToHackMeets < ActiveRecord::Migration
  def change
    add_column :hack_meets, :hack_leader_id, :integer
  end
end
