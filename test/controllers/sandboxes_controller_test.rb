require 'test_helper'

class SandboxesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sandbox = sandboxes(:one)
  end

  test "should get index" do
    get sandboxes_url
    assert_response :success
  end

  test "should get new" do
    get new_sandbox_url
    assert_response :success
  end

  test "should create sandbox" do
    assert_difference('Sandbox.count') do
      post sandboxes_url, params: { sandbox: { name: @sandbox.name } }
    end

    assert_redirected_to sandbox_url(Sandbox.last)
  end

  test "should show sandbox" do
    get sandbox_url(@sandbox)
    assert_response :success
  end

  test "should get edit" do
    get edit_sandbox_url(@sandbox)
    assert_response :success
  end

  test "should update sandbox" do
    patch sandbox_url(@sandbox), params: { sandbox: { name: @sandbox.name } }
    assert_redirected_to sandbox_url(@sandbox)
  end

  test "should destroy sandbox" do
    assert_difference('Sandbox.count', -1) do
      delete sandbox_url(@sandbox)
    end

    assert_redirected_to sandboxes_url
  end
end
