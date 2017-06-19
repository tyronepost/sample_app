require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
    get signup_path
    before_count = User.count
    post users_path, user: {  name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar"  }
    assert_equal before_count, User.count
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end

  test "valid signup information" do
    get signup_path
    expected_count = User.count + 1
    post_via_redirect users_path, user: { name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" }
    assert_equal expected_count, User.count
    assert_template 'users/show'
    assert_select 'div.alert-success'
    assert_not_nil flash
    assert_not flash[:danger]
    assert_not_nil flash[:success]
  end
end
