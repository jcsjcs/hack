class HackVenue < ActiveRecord::Base
  has_many :hack_meets

  validates_presence_of :venue

  def to_s
    self.venue
  end
end
