require 'test_helper'

class FollersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get follers_index_url
    assert_response :success
  end

end
