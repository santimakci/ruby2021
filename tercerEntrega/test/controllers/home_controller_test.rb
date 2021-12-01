require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get home_create_url
    assert_response :success
  end
end
