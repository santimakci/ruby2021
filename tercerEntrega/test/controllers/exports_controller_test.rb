require "test_helper"

class ExportsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get exports_show_url
    assert_response :success
  end

  test "should get new" do
    get exports_new_url
    assert_response :success
  end

  test "should get download" do
    get exports_download_url
    assert_response :success
  end
end
