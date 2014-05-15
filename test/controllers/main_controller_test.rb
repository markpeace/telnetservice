require 'test_helper'

class MainControllerTest < ActionController::TestCase
  test "should get command" do
    get :command
    assert_response :success
  end

end
