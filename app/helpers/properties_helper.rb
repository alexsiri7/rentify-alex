module PropertiesHelper
end

class Rentify
  def searchSimilarProperties(number_of_rooms, point)
    initial_properties = @properties
    filtered_by_bedroom_properties = filter_by_number_of_rooms number_of_rooms, initial_properties
    filtered_final = filter_by_distance point, filtered_by_bedroom_properties
    sort_by_distance(point, filtered_final)
  end
  def setPropertyList(list)
    @properties = list
  end
  private
  def filter_by_number_of_rooms(number_of_rooms, initial_properties)
    initial_properties.select { |property| property.number_of_rooms >= number_of_rooms}
  end
  def filter_by_distance(point, initial_properties)
    initial_properties.select { |property| point.distance_to(property) <= 20}
  end
  def sort_by_distance(point, initial_properties)
    initial_properties.sort { |property1, property2| point.distance_to(property1.point) <=> point.distance_to(property2.point)}
  end
end

class Point
  attr_reader :latitude, :longitude
  def initialize(latitude, longitude)
    @latitude=latitude
    @longitude=longitude
  end
  def distance_to(point)
    haversine(point.latitude, point.longitude)
  end
  def haversine(destination_lat, destination_long)
    #Got from http://www.movable-type.co.uk/scripts/latlong.html
    radius = 6371;
    dLat = radians(destination_lat-@latitude);
    dLon = radians(destination_long-@longitude);
    lat1 = radians(@latitude);
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