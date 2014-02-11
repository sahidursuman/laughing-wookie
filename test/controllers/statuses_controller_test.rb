require 'test_helper'

class StatusesControllerTest < ActionController::TestCase
  setup do
    @status = statuses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create status when logged in" do
    sign_in users(:jason)

    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: @status.full_name }
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create status for the current user when logged in" do
    sign_in users(:jason)
    
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:jim).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should get edit when logged in" do
    sign_in users(:jason)
    get :edit, id: @status
    assert_response :success
  end

  test "should redirect status update when not logged in" do
    put :update, id: @status, status: { content: @status.content, user_id: @status.full_name }
    assert_response :redirect
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update a status for the current user when logged in" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content, user_id: users(:jim).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should not update a status if nothing has changed" do
    sign_in users(:jason)
    put :update, id: @status, status: { content: @status.content, user_id: users(:jim).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:jason).id
  end

  test "should destroy status" do
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end
