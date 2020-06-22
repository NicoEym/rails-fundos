require 'test_helper'

class FundTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


  test "should not save fund without fundname" do
    fund = Fund.new(name: "Vitesse")
    assert_not fund.save, "Saved the fund without a name"
  end
end
