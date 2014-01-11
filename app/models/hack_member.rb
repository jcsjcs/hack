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
     {id: "fullname", name: "Name", field: "fullname", formatter: "ShowLinkTextFormatter", width: 200},
     {id: "hack_attendances_count", name: "Hacks", field: "hack_attendances_count", cssClass: 'numeric'},
     {id: "email", name: "email", field: "email", width: 200},
     {id: "email_ok", name: "Email ok", field: "email_ok", formatter: 'BooleanFormatter', cssClass: 'centred'},
     {id: "email_issues", name: "Email issues", field: "email_issues", width: 120},
     {id: "tel_combined", name: "Tel. numbers", field: "tel_combined", width: 200},
     {id: "non_hacker", name: "Non hacker?", field: "non_hacker", formatter: 'BooleanFormatter', cssClass: 'centred'}
   ]
  end

  def to_grid_row
    row = {}
    (%w{hack_attendances_count email email_ok email_issues non_hacker id}).each {|f| row[f] = self.send(f) }
    row['tel_combined'] = self.combined_phone_nos
    row['fullname']     = self.full_name
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
