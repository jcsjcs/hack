class HackMeet < ActiveRecord::Base
  has_many :hack_members, :through => :hack_attendances
  has_many :hack_attendances
  has_many :occasional_groups
  belongs_to :hack_venue
  belongs_to :hack_leader, :class_name => 'HackMember', :foreign_key => :hack_leader_id
  has_and_belongs_to_many :plant_types

  validates_presence_of :hack_leader_id

  before_save :set_year_month

  def self.grid_columns
   [
     {id: "actions", name: "action", field: "actions", width: 50, sortable: false, formatter: "slickActionCollectionFormatter", unfiltered: true},
     {id: "year_month", name: "Month", field: "year_month", formatter: "YearMonthFormatter", width: 200, sortable: true},
     {id: "hack_date", name: "Date", field: "hack_date", width: 120, sortable: true},
     {id: "hack_attendances_count", name: "Attendance", field: "combined_attendance", cssClass: 'numeric', width: 120, sortable: true}, #, formatter: 'HackAttendanceFormatter'
     {id: "start_time", name: "Start", field: "start_time", sortable: true},
#     {id: "work_area", name: "Work area", field: "work_area", width: 120, sortable: true},
     {id: "notes", name: "Notes", field: "notes", width: 120},
     {id: "hack_venue", name: "Venue", field: "hack_venue", width: 120, sortable: true},
     {id: "social", name: "Social", field: "social", formatter: 'BooleanFormatter', cssClass: 'centred'}
   ]
  end

  def to_grid_row
    row = {}
    (%w{hack_date start_time notes social combined_attendance id}).each {|f| row[f] = self.send(f) }
    #row['year_month'] = "#{self.hack_year}: #{self.hack_date.strftime('%B')}" # could do this as yyyy-mm & use a formatter. == sortable.
    row['year_month'] = "#{self.hack_year}-#{self.hack_date.strftime('%m')}" # could do this as yyyy-mm & use a formatter. == sortable.
    row['hack_venue'] = self.hack_venue.to_s
    row['actions'] = []
    row['actions'] << {type: "action",body: {prompt_text: "",icon: "view",href: "#{"/hack_meets/#{id}"}",text: "Show",cls: "action_link"}}
    row['actions'] << {type: "action",body: {prompt_text: "",icon: "edit",href: "#{"/hack_meets/#{id}/edit"}",text: "Edit",cls: "action_link"}}
    row['actions'] << {type: "separator",}
    row['actions'] << {type: "action",body: {prompt_text: "",icon: "user",href: "#{"/hack_meets/#{id}/attendance"}",text: "Attendance",cls: "action_link"}}
    row['actions'] << {type: "separator",}
    row['actions'] << {type: "action",body: {prompt_text: "Are you sure?",icon: "delete", href: "#{"/hack_meets/#{id}"}",text: "Delete",cls: "action_link", method: "delete"}}
    row
  end

  def collect_names(add_to, members)
    members.each do |member|
      add_to << member[:name]
      collect_names(add_to, member[:subnodes])
    end
  end

  # List members in a sentence:
  # * Alphabetic order.
  # * Leader listed last.
  # * Members that should be are grouped together.
  def hack_members_for_newsletter
    member_hash = {}
    hack_members.name_seq.each do | member |
      member_hash[member.informal_name] = {:name     => member.informal_name,
                                           :grp_with => member.group_with_id.nil? ? nil : member.group_with.informal_name,
                                           :subnodes => []}
    end
    member_hash.each do |_, item|
      parent = member_hash[item[:grp_with]]
      parent[:subnodes] << item if parent
    end
    unique_array = member_hash.reject {|_, item| member_hash.has_key? item[:grp_with] }.values
    ar           = []
    collect_names(ar, unique_array)

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

  def previous
    @prev_hack ||= HackMeet.where("hack_date < '#{hack_date}'").order('hack_date DESC').first
  end

  def next
    @next_hack ||= HackMeet.where("hack_date > '#{hack_date}'").order('hack_date').first
  end

  def combined_attendance
    occasional_groups.sum(:no_of_attendees) + hack_attendances_count
  end

private
  def set_year_month
    self.hack_year  = self.hack_date.year
    self.hack_month = self.hack_date.month
  end

end
