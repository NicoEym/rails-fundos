require 'test_helper'
require 'date'

class CalendarTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

   test "should not save calendar without day" do
    calendar = Calendar.new
    assert_not calendar.save, "Saved the fund without a name"
  end

  test "should not save calendar without day as a date" do
    date = "toto"
    calendar = Calendar.new(day: date)
    assert_not calendar.save, "Saved the fund without a name"
  end

  test "should save calendar with day as date" do
    date = Date.new(2020, 05, 26)
    calendar = Calendar.new(day: date)
    assert calendar.save, "Saved the date"
  end
end
