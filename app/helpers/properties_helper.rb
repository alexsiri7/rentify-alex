module PropertiesHelper
end

class SimilarPropertiesFinder
  MAX_ALLOWED_DISTANCE = 20

  def initialize(number_of_rooms, point)
    @number_of_rooms = number_of_rooms
    @point = point
  end

  def run
    filter_by_number_of_rooms
    filter_by_distance
    sort_by_distance
    @properties
  end

  def set_property_list(list)
    @properties = list
  end

  private

  def filter_by_number_of_rooms
    @properties.select! { |property| property.number_of_rooms >= @number_of_rooms}
  end


  def filter_by_distance
    @properties.select! { |property| @point.distance_to(property.location) <= MAX_ALLOWED_DISTANCE}
  end

  def sort_by_distance
    @properties.sort! { |property1, property2| @point.distance_to(property1.location) <=> @point.distance_to(property2.location)}
  end

end

class Point
  attr_reader :latitude, :longitude
  def initialize(latitude, longitude)
    @latitude=latitude
    @longitude=longitude
  end
  def distance_to(point)
    haversine_distance(point.latitude, point.longitude)
  end

  private

  def haversine_distance(destination_lat, destination_long)
    #Got from http://www.movable-type.co.uk/scripts/latlong.html
    radius = 6371;
    deltaLatitude = degrees_to_radians(destination_lat-@latitude);
    deltaLongitude = degrees_to_radians(destination_long-@longitude);
    latitude_origin = degrees_to_radians(@latitude);
    latitude_destination = degrees_to_radians(destination_lat);

    a = Math.sin(deltaLatitude/2) * Math.sin(deltaLatitude/2) +
        Math.sin(deltaLongitude/2) * Math.sin(deltaLongitude/2) * Math.cos(latitude_origin) * Math.cos(latitude_destination);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    distance = radius * c;
  end
  def degrees_to_radians(degrees)
    degrees * Math::PI / 180
  end

end