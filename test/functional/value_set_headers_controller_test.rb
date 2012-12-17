require 'test_helper'

class ValueSetHeadersControllerTest < ActionController::TestCase
  setup do
    @value_set_header = value_set_headers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:value_set_headers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create value_set_header" do
    assert_difference('ValueSetHeader.count') do
      post :create, value_set_header: { name: @value_set_header.name }
    end

    assert_redirected_to value_set_header_path(assigns(:value_set_header))
  end

  test "should show value_set_header" do
    get :show, id: @value_set_header
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @value_set_header
    assert_response :success
  end

  test "should update value_set_header" do
    put :update, id: @value_set_header, value_set_header: { name: @value_set_header.name }
    assert_redirected_to value_set_header_path(assigns(:value_set_header))
  end

  test "should destroy value_set_header" do
    assert_difference('ValueSetHeader.count', -1) do
      delete :destroy, id: @value_set_header
    end

    assert_redirected_to value_set_headers_path
  end
end
