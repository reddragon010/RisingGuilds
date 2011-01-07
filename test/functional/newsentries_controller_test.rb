require 'test_helper'

class NewsentriesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:newsentries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create newsentry" do
    assert_difference('Newsentry.count') do
      post :create, :newsentry => { }
    end

    assert_redirected_to newsentry_path(assigns(:newsentry))
  end

  test "should show newsentry" do
    get :show, :id => newsentries(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => newsentries(:one).to_param
    assert_response :success
  end

  test "should update newsentry" do
    put :update, :id => newsentries(:one).to_param, :newsentry => { }
    assert_redirected_to newsentry_path(assigns(:newsentry))
  end

  test "should destroy newsentry" do
    assert_difference('Newsentry.count', -1) do
      delete :destroy, :id => newsentries(:one).to_param
    end

    assert_redirected_to newsentries_path
  end
end
