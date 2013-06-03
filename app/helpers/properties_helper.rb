module PropertiesHelper
end

class Rentify
  def searchSimilarProperties(number_of_rooms, latitude, longitude)
    initial_properties = @properties
    filtered_by_bedroom_properties = filter_by_number_of_rooms number_of_rooms, initial_properties
    filtered_final = filter_by_distance latitude, longitude, filtered_by_bedroom_properties
    sort_by_distance(latitude, longitude, filtered_final)
  end
  def setPropertyList(list)
    @properties = list
  end
  def distance_to(lat, long, property)
    DistanceCalculator.new(lat,long).haversine(property.latitude,property.longitude)
  end
  private
  def filter_by_number_of_rooms(number_of_rooms, initial_properties)
    initial_properties.select { |property| property.number_of_rooms >= number_of_rooms}
  end
  def filter_by_distance(latitude, longitude, initial_properties)
    initial_properties.select { |property| distance_to(latitude, longitude, property) <= 20}
  end
  def sort_by_distance(latitude, longitude, initial_properties)
    initial_properties.sort { |property1, property2| distance_to(latitude, longitude, property1) <=> distance_to(latitude, longitude, property2)}
  end
end



class DistanceCalculator
  def initialize(origin_lat, origin_long)
    @location = Point.new(origin_lat, origin_long)
  end
  def haversine(destination_lat, destination_long)
    #Got from http://www.movable-type.co.uk/scripts/latlong.html
    radius = 6371;
    dLat = radians(destination_lat-@location.latitude);
    dLon = radians(destination_long-@location.longitude);
    lat1 = radians(@location.latitude);
    lat2 = radians(destination_lat);

    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
        Math.sin(dLon/2) * Math.sin(dLon/2) * Math.cos(lat1) * Math.cos(lat2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    distance = radius * c;
  end
  def radians(degrees)
    degrees * Math::PI / 180
  end
end

class Point
  attr_reader :latitude, :longitude
  def initialize(latitude, longitude)
    @latitude=latitude
    @longitude=longitude
  end
end