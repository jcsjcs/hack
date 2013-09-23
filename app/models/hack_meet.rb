class HackMeet < ActiveRecord::Base
  has_many :hack_members, :through => :hack_attendances
  has_many :hack_attendances
  belongs_to :hack_venue
  has_and_belongs_to_many :plant_types

  before_save :set_year_month

  def hack_members_for_newsletter
    ar = []
    self.hack_members.hack_seq.each do |member|
      ar << member.informal_name
    end
    if ar.include? 'James Silberbauer'
      ar.delete 'James Silberbauer'
      ar.push 'James Silberbauer'
    end
    ar.blank? ? 'None.' : ar.to_sentence(:last_word_connector => ' and ')
  end

  # List of plants dealt with at the hack in a sentence.
  def plant_list
    self.plant_types.order('name').map {|m| m.name}.to_sentence
  end

private
  def set_year_month
    self.hack_year  = self.hack_date.year
    self.hack_month = self.hack_date.month
  end

end
