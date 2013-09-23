class HackAttendance < ActiveRecord::Base
  belongs_to :hack_meet, :counter_cache => true
  belongs_to :hack_member, :counter_cache => true
end
