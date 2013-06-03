class Property < ActiveRecord::Base
  attr_accessible :is_available, :latitude, :longitude, :name, :number_of_rooms
end
