require 'test_helper'

class PointTest < ActiveSupport::TestCase
  LAT = 0.0000
  LONG = 0.0000
  LAT_3KM = LAT+0.027
  LONG_4KM = LONG+0.036

  def setup
    @origin = Point.new(LAT, LONG)

    @close_latitude = Point.new(LAT_3KM,LONG);
    @close_longitude = Point.new(LAT, LONG_4KM);
    @close_diagonal = Point.new(LAT_3KM, LONG_4KM);
  end

  def test_calculate_distance_latitude
    distance = @origin.distance_to(@close_latitude)
    assert_in_delta 3, distance, 0.01
  end
  def test_calculate_distance_longitude
    distance = @origin.distance_to(@close_longitude)
    assert_in_delta 4, distance, 0.01
  end

  def test_calculate_distance_diagonal
    distance = @origin.distance_to(@close_diagonal)
    assert_in_delta 5, distance, 0.01 #Trigonometry, baby!
  end
()
end
