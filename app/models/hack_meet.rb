class HackMeet < ActiveRecord::Base
  has_many :hack_members, :through => :hack_attendances
  has_many :hack_attendances
  belongs_to :hack_venue
  belongs_to :hack_leader, :class_name => 'HackMember', :foreign_key => :hack_leader_id
  has_and_belongs_to_many :plant_types

  validates_presence_of :hack_leader_id

  before_save :set_year_month

  def self.grid_columns
   [
     {id: "year_month", name: "Month", field: "year_month", formatter: "ShowLinkTextFormatter", width: 200},
     {id: "hack_date", name: "Date", field: "hack_date", width: 100, sortable: true},
     {id: "hack_attendances_count", name: "Attendances", field: "hack_attendances_count", formatter: 'HackAttendanceFormatter', width: 150, sortable: true},
     {id: "start_time", name: "Start", field: "start_time", sortable: true},
     {id: "work_area", name: "Work area", field: "work_area", width: 120, sortable: true},
     {id: "notes", name: "Notes", field: "notes", width: 120},
     {id: "hack_venue", name: "Venue", field: "hack_venue", width: 120, sortable: true},
     {id: "social", name: "Social", field: "social", formatter: 'BooleanFormatter', cssClass: 'centred'}
   ]
  end

  def to_grid_row
    row = {}
    (%w{hack_date start_time work_area notes social hack_attendances_count id}).each {|f| row[f] = self.send(f) }
    row['year_month'] = "#{self.hack_year}: #{self.hack_date.strftime('%B')}"
    row['hack_venue'] = self.hack_venue.to_s
    row
  end

  def hack_members_for_newsletter
    ar = []
    gr = []

    hack_members.hack_seq.each do |member|
      if member.group_with_id.nil? || !hack_member_ids.include?(member.group_with_id)
        ar << {member.informal_name => []}
      else
        gr << {member.group_with.informal_name => member.informal_name}
      end
    end
    gr.each {|g| elem = ar.find {|a| a.keys.include?(g.keys.first) }; elem[g.keys.first] << g.values.first }
    ar = ar.map {|a| [a.keys.first, a.values.first] }.flatten

    leader = self.hack_leader.informal_name
    if ar.include? leader
      ar.delete leader
      ar.push leader
    end

    ar.blank? ? 'None.' : ar.to_sentence(:last_word_connector => ' and ')
  end

  # List of plants dealt with at the hack in a sentence.
  def plant_list
    self.plant_types.order('name').map {|m| m.name}.to_sentence
  end

private
  def set_year_month
    self.hack_year  = self.hack_date.year
    self.hack_month = self.hack_date.month
  end

end
