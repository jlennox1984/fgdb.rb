require 'test_helper'

class SkedsControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:skeds)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_sked
    assert_difference('Sked.count') do
      post :create, :sked => { }
    end

    assert_redirected_to sked_path(assigns(:sked))
  end

  def test_should_show_sked
    get :show, :id => skeds(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => skeds(:one).id
    assert_response :success
  end

  def test_should_update_sked
    put :update, :id => skeds(:one).id, :sked => { }
    assert_redirected_to sked_path(assigns(:sked))
  end

  def test_should_destroy_sked
    assert_difference('Sked.count', -1) do
      delete :destroy, :id => skeds(:one).id
    end

    assert_redirected_to skeds_path
  end
end
