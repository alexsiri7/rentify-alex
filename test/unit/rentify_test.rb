require 'test_helper'

class RentifyTest < ActiveSupport::TestCase
  LAT = 0.0000
  LONG = 0.0000
  NUMBER_OF_BEDROOMS = 2
  LAT_3KM = LAT+0.027
  LONG_4KM = LONG+0.036

  LAT_100M = LAT+0.001

  LAT_OVER_20KM = LAT+1

  SMALL_NUMBER_OF_BEDROOMS = NUMBER_OF_BEDROOMS+2

  LARGE_NUMBER_OF_BEDROOMS = NUMBER_OF_BEDROOMS-1

  def setup
    @rentify = Rentify.new

    @original_property = Property.new({:name=>'Original Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT, :longitude=>LONG})
    @close_property = Property.new({:name=>'Close Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_100M, :longitude=>LONG});
    @further_property = Property.new({:name=>'Further Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_3KM, :longitude=>LONG})
    @far_property = Property.new({:name=>'Further Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_OVER_20KM, :longitude=>LONG})

    @bigger_property = Property.new({:name=>'Bigger Property', :number_of_rooms=>SMALL_NUMBER_OF_BEDROOMS, :latitude=>LAT_100M, :longitude=>LONG});
    @smaller_property = Property.new({:name=>'Smaller Property', :number_of_rooms=>LARGE_NUMBER_OF_BEDROOMS, :latitude=>LAT_100M, :longitude=>LONG});

    @close_property_latitude = Property.new({:name=>'Close Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_3KM, :longitude=>LONG});
    @close_property_longitude = Property.new({:name=>'Close Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT, :longitude=>LONG_4KM});
    @close_property_diagonal = Property.new({:name=>'Close Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_3KM, :longitude=>LONG_4KM});
  end

  def test_find_same_property
    expected_list = [@original_property]
    @rentify.setPropertyList(expected_list)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

  def test_order_by_distance
    fixture_properties = [
        @further_property,
        @close_property
    ]
    expected_list = [
        @close_property,
        @further_property
    ]
    @rentify.setPropertyList(fixture_properties)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

  def test_do_not_reorder_by_distance_if_already_ordered
    fixture_properties = [
        @close_property,
        @further_property
    ]
    expected_list = [
        @close_property,
        @further_property
    ]
    @rentify.setPropertyList(fixture_properties)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

  def test_filter_out_if_lesser_number_of_bedrooms
    fixture_properties = [
        @smaller_property
    ]
    expected_list = [
    ]
    @rentify.setPropertyList(fixture_properties)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

  def test_filter_in_if_greater_number_of_bedrooms
    fixture_properties = [
        @bigger_property
    ]
    expected_list = [
        @bigger_property
    ]
    @rentify.setPropertyList(fixture_properties)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

  def test_calculate_distance_latitude
    distance = @rentify.distance_to(LAT, LONG, @close_property_latitude)
    assert_in_delta 3, distance, 0.01
  end
  def test_calculate_distance_longitude
    distance = @rentify.distance_to(LAT, LONG, @close_property_longitude)
    assert_in_delta 4, distance, 0.01
  end

  def test_calculate_distance_diagonal
    distance = @rentify.distance_to(LAT, LONG, @close_property_diagonal)
    assert_in_delta 5, distance, 0.01 #Trigonometry, baby!
  end

  def test_filter_by_distance
    fixture_properties = [
        @far_property
    ]
    expected_list = [
    ]
    @rentify.setPropertyList(fixture_properties)
    list = @rentify.searchSimilarProperties(NUMBER_OF_BEDROOMS, LAT, LONG)
    assert_equal expected_list,list
  end

end