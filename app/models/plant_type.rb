class PlantType < ActiveRecord::Base
  has_and_belongs_to_many :hack_meets

  validates_presence_of :name
end
