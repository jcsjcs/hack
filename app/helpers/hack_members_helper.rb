module HackMembersHelper

  def combined_phone_nos(member)
    [member.tel_home, member.tel_office, member.tel_cell].select{|t| !t.nil? && t != ''}.join(', ')
  end

end
