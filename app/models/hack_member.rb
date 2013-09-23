class HackMember < ActiveRecord::Base
  has_many :hack_attendances
  has_many :hack_meets, :through => :hack_attendances
  
  # named_scope :hack_seq, :order => 'hack_attendances_count > 0 DESC, non_hacker, UPPER(surname), first_name'
  scope :hack_seq, -> {order('hack_attendances_count > 0 DESC, non_hacker, UPPER(surname), first_name') }
  # named_scope :hack_seq_desc, :order => 'hack_attendances_count > 0, non_hacker DESC, UPPER(surname) DESC, first_name DESC'
  scope :hack_seq_desc, -> {order('hack_attendances_count > 0, non_hacker DESC, UPPER(surname) DESC, first_name DESC') }
  # named_scope :name_seq, :order => 'UPPER(surname), first_name'
  scope :name_seq, -> {order('UPPER(surname), first_name') }
  # named_scope :name_seq_desc, :order => 'UPPER(surname) DESC, first_name DESC'
  scope :name_seq_desc, -> {order('UPPER(surname) DESC, first_name DESC') }

  validates_presence_of :surname

  GRID_COLS = %w{title initials first_name surname tel_home tel_office tel_cell email email_ok email_issues non_hacker comments contact_via group_with hack_attendances_count}

  def self.grid_columns
    cols = []
    GRID_COLS.each {|f| cols << {id: "#{f}", name: "#{f.humanize}", field: "#{f}" } }
    cols
  end

  def to_grid_row
    row = {}
    (GRID_COLS+['id']).each {|f| row[f] = self.send(f) }
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
      [tel_home, tel_office, tel_cell].select{|t| !t.nil? && t != ''}.join(', ')
    end
  end

end
