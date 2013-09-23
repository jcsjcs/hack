class HackMember < ActiveRecord::Base
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

end
