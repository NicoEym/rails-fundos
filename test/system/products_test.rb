require "application_system_test_case"

class ProductsTest < ApplicationSystemTestCase
 test "visiting the index" do
    visit "/"
    assert_selector "h1", text: "Fundos"
  end


  test "lets a signed in user and check if he can see the areas" do
    login_as users(:george)
    visit "/areas/"

    assert_selector ".card", count: Area.count
  end


   test "lets a signed in user and check if he can see the funds" do
    login_as users(:george)
    visit "/funds/"

    assert_selector ".card", count: Fund.count
  end

  # test "lets a signed in user and check if he can see the areas" do
  #   login_as users(:george)
  #   visit "/areas/"

  #   click_on 'Create Product'
  #   assert_equal "/areas/", page.current_path

  # end
end
