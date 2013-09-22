json.array!(@hack_members) do |hack_member|
  json.extract! hack_member, :title, :initials, :first_name, :surname, :tel_home, :tel_office, :tel_cell, :email, :email_ok, :email_issues, :non_hacker, :comments, :contact_via, :group_with, :hack_attendances_count
  json.url hack_member_url(hack_member, format: :json)
end
