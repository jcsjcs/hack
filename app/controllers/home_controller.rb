class HomeController < ApplicationController
  def welcome
    @active_hackers   = HackMember.count(:conditions => 'hack_attendances_count > 0')
    @inactive_hackers = HackMember.count(:conditions => 'hack_attendances_count = 0')
    @hack_count = HackMeet.count
    if @hack_count > 0
      @hack_cancelled_count  = HackMeet.count(:conditions => 'hack_attendances_count = 0')
      @hack_since            = HackMeet.order('hack_year, hack_month').first.hack_date
      @hack_attendance_count = HackAttendance.count
    end

    hack_months = HackMeet.all(:select => 'hack_year, hack_month, hack_attendances_count', :order => 'hack_year, hack_month')
    @hack_stats = {}
    hack_months.each do |stat|
      @hack_stats[stat.hack_year] ||= [0,0,0,0,0,0,0,0,0,0,0,0]
      @hack_stats[stat.hack_year][stat.hack_month-1] = stat.hack_attendances_count
    end

  end
end
