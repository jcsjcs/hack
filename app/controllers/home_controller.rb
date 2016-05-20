class HomeController < ApplicationController
  def welcome
    @active_hackers   = HackMember.count(:conditions => 'hack_attendances_count > 0')
    @inactive_hackers = HackMember.count(:conditions => 'hack_attendances_count = 0')
    @hack_count = HackMeet.count
    if @hack_count > 0
      @hack_cancelled_count  = HackMeet.count(:conditions => 'hack_attendances_count = 0')
      @hack_since            = HackMeet.order('hack_year, hack_month').first.hack_date
      @hack_attendance_count = HackAttendance.count + OccasionalGroup.sum(:no_of_attendees)
    end

    hack_months = HackMeet.all(:select => 'hack_year, hack_month, hack_attendances_count', :order => 'hack_year, hack_month')
    @hack_stats = {}
    hack_months.each do |stat|
      @hack_stats[stat.hack_year] ||= [0,0,0,0,0,0,0,0,0,0,0,0]
      @hack_stats[stat.hack_year][stat.hack_month-1] = stat.hack_attendances_count
    end

  end

  def run_database_backup
    require 'open3'
    fn = '/home/james/bin/hack_pg_backup.sh'
    if File.exist?(fn)
      # @backup_result = `#{fn}`
      # if $?.exitstatus != 0
      #   @backup_result.insert(0, "AN ERROR OCCURRED:\nPlease try to run manually\n\n")
      # end
      stdout_str, stderr_str, status = Open3.capture3(fn)
      #sin, stdout_str, stderr_str, thr = Open3.capture3(fn) # UNTIL JRuby 1.7.1
      if status.exitstatus == 0
      #if stderr_str.blank? # UNTIL JRuby 1.7.1
        @backup_result = stdout_str
      else
        @backup_result = "AN ERROR OCCURRED:\n\n#{stderr_str}"
      end
    else
      @backup_result = "There is no backup process defined at #{fn}."
    end
  end

end
