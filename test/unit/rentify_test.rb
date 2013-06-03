require 'test_helper'

class RentifyTest < ActiveSupport::TestCase
  LONG = 0.0000
  LONG_4KM = LONG+0.036

  LAT = 0.0000
  LAT_3KM = LAT+0.027
  LAT_LESS_1KM = LAT+0.001
  LAT_OVER_20KM = LAT+1

  NUMBER_OF_BEDROOMS = 2
  SMALL_NUMBER_OF_BEDROOMS = NUMBER_OF_BEDROOMS+2
  LARGE_NUMBER_OF_BEDROOMS = NUMBER_OF_BEDROOMS-1

  def setup
    @origin = Point.new(LAT, LONG)
    @rentify = SimilarPropertiesFinder.new(NUMBER_OF_BEDROOMS, @origin)

    @close_property = Property.new({:name=>'Close Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_LESS_1KM, :longitude=>LONG});
    @further_property = Property.new({:name=>'Further Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_3KM, :longitude=>LONG})
  end

  def test_find_same_property
    @origin_property = Property.new({:name=>'Origin Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT, :longitude=>LONG})
    expected_list = [@origin_property]
    @rentify.setPropertyList(expected_list)

    list = @rentify.run()

    assert_equal expected_list,list
  end

  def test_order_by_distance
    fixture_properties = [@further_property,@close_property]
    expected_list = [@close_property,@further_property]
    @rentify.setPropertyList(fixture_properties)

    list = @rentify.run()

    assert_equal expected_list,list
  end

  def test_do_not_reorder_by_distance_if_already_ordered
    fixture_properties = [@close_property,@further_property]
    expected_list = [@close_property,@further_property]
    @rentify.setPropertyList(fixture_properties)

    list = @rentify.run()

    assert_equal expected_list,list
  end

  def test_filter_out_if_lesser_number_of_bedrooms
    @smaller_property = Property.new({:name=>'Smaller Property', :number_of_rooms=>LARGE_NUMBER_OF_BEDROOMS, :latitude=>LAT_LESS_1KM, :longitude=>LONG});
    fixture_properties = [@smaller_property]
    expected_list = []
    @rentify.setPropertyList(fixture_properties)

    list = @rentify.run()

    assert_equal expected_list,list
  end

  def test_filter_in_if_greater_number_of_bedrooms
    @bigger_property = Property.new({:name=>'Bigger Property', :number_of_rooms=>SMALL_NUMBER_OF_BEDROOMS, :latitude=>LAT_LESS_1KM, :longitude=>LONG});

    fixture_properties = [@bigger_property]
    expected_list      = [@bigger_property]
    @rentify.setPropertyList(fixture_properties)

    list = @rentify.run()

    assert_equal expected_list,list
  end

  def test_filter_by_distance
    @far_property = Property.new({:name=>'Further Property',:number_of_rooms=>NUMBER_OF_BEDROOMS, :latitude=>LAT_OVER_20KM, :longitude=>LONG})
    fixture_properties = [@far_property]
    expected_list      = []
    @rentify.setPropertyList(fixture_properties)

    list = @rentify.run()

    assert_equal expected_list,list
  end

end
