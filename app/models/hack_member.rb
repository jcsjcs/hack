class HackMember < ActiveRecord::Base
  has_many :hack_attendances
  has_many :hack_meets, :through => :hack_attendances
  belongs_to :contact_via, :class_name => 'HackMember'
  belongs_to :group_with,  :class_name => 'HackMember'

  scope :hack_seq,      -> {order('hack_attendances_count > 0 DESC, non_hacker, UPPER(surname), first_name') }
  scope :hack_seq_desc, -> {order('hack_attendances_count > 0, non_hacker DESC, UPPER(surname) DESC, first_name DESC') }
  scope :name_seq,      -> {order('UPPER(surname), first_name') }
  scope :name_seq_desc, -> {order('UPPER(surname) DESC, first_name DESC') }

  validates_presence_of :surname

  def self.grid_columns
   [
     {id: "actions", name: "action", field: "actions", width: 50, sortable: false, formatter: "slickActionCollectionFormatter", unfiltered: true},
     {id: "fullname", name: "Name", field: "fullname", width: 200, sortable: true}, #, formatter: "ShowLinkTextFormatter"
     {id: "hack_attendances_count", name: "Hacks", field: "hack_attendances_count", cssClass: 'numeric', sortable: true},
     {id: "email", name: "email", field: "email", width: 200, sortable: true},
     {id: "email_ok", name: "Email ok", field: "email_ok", formatter: 'BooleanFormatter', cssClass: 'centred', sortable: true},
     {id: "email_issues", name: "Email issues", field: "email_issues", width: 120, sortable: true},
     {id: "tel_combined", name: "Tel. numbers", field: "tel_combined", width: 200},
     {id: "non_hacker", name: "Non hacker?", field: "non_hacker", formatter: 'BooleanFormatter', cssClass: 'centred'}
   ]
  end

  def to_grid_row
    row = {}
    (%w{hack_attendances_count email email_issues id}).each {|f| row[f] = self.send(f) }
    row['tel_combined'] = self.combined_phone_nos
    row['fullname']     = self.full_name
    row['email_ok']     = self.email_ok ? 'Y' : 'N'
    row['non_hacker']   = self.non_hacker ? 'Y' : 'N'
    row['actions'] = []
    row['actions'] << {type: "action",body: {prompt_text: "",icon: "view",href: "#{"/hack_members/#{id}"}",text: "Show",cls: "action_link"}}
    row['actions'] << {type: "action",body: {prompt_text: "",icon: "edit",href: "#{"/hack_members/#{id}/edit"}",text: "Edit",cls: "action_link"}}
    row['actions'] << {type: "action",body: {prompt_text: "Are you sure?",icon: "delete", href: "#{"/hack_members/#{id}"}",text: "Delete",cls: "action_link", method: "delete"}}

    row
  end

  # Return full name of Member (Title, First Name and Surname)
  def full_name
    @full_name ||= [title, first_name, surname].compact.join(' ')
  end

  # Sort-name (Hackers before non-hackers)
  def sort_name
    prefix = self.hack_attendances_count > 0 ? 'Hacker ' : 'Non-hacker: '
    "#{prefix} #{surname} #{first_name}"
  end

  # Return informal name of Member (First Name and Surname)
  def informal_name
    @informal_name ||= [first_name, surname].compact.join(' ')
  end

  # Return a list of all phone nos grouped together
  def combined_phone_nos(only_one=false)
    if only_one
      [tel_home, tel_office, tel_cell].select{|t| !t.nil? && t != ''}.first
    else
      [tel_home, tel_office, tel_cell].select{|t| !t.nil? && t.strip != ''}.join(', ')
    end
  end

  def other_hackers
    if self.new_record?
      HackMember.order('surname, first_name').all.unshift(HackMember.new)
    else
      HackMember.where("id <> #{self.id}").order('surname, first_name').all.unshift(HackMember.new)
    end
  end

end
