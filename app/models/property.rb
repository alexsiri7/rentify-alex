class Property < ActiveRecord::Base
  attr_accessible :is_available, :latitude, :longitude, :name, :number_of_rooms

  def location
    Point.new(latitude, longitude)
  end

  def ==(obj)
    name==obj.name
  end

  def to_s
    name
  end
end
