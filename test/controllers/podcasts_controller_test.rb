require 'test_helper'

class PodcastsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
