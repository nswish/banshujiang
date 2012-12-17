require 'test_helper'

class ValueSetBodiesControllerTest < ActionController::TestCase
  setup do
    @value_set_body = value_set_bodies(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:value_set_bodies)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create value_set_body" do
    assert_difference('ValueSetBody.count') do
      post :create, value_set_body: { name: @value_set_body.name, value: @value_set_body.value, value_set_header_id: @value_set_body.value_set_header_id }
    end

    assert_redirected_to value_set_body_path(assigns(:value_set_body))
  end

  test "should show value_set_body" do
    get :show, id: @value_set_body
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @value_set_body
    assert_response :success
  end

  test "should update value_set_body" do
    put :update, id: @value_set_body, value_set_body: { name: @value_set_body.name, value: @value_set_body.value, value_set_header_id: @value_set_body.value_set_header_id }
    assert_redirected_to value_set_body_path(assigns(:value_set_body))
  end

  test "should destroy value_set_body" do
    assert_difference('ValueSetBody.count', -1) do
      delete :destroy, id: @value_set_body
    end

    assert_redirected_to value_set_bodies_path
  end
end
