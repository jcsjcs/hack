module ApplicationHelper

  def app_name
    'HNR Hacks'
  end

  def hack_desc(year, month)
    #"#{year}: #{Time::RFC2822_MONTH_NAME[month-1]}"
    "#{year}: #{['January', 'February', 'March', 'April', 'May', 'June',
                 'July', 'August', 'September', 'October', 'November', 'December'][month-1]}"
  end

end
