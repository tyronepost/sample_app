require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    before_count = User.count
    post users_path, user: {  name: "",
                              email: "user@invalid",
                              password: "foo",
                              password_confirmation: "bar"  }
    assert_equal before_count, User.count
    assert_template 'users/new'
  end

  test "valid signup information with account activation" do
    get signup_path
    expected_count = User.count + 1
    post_via_redirect users_path, user: { name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_confirmation: "password" }
    assert_equal expected_count, User.count
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try logging in before activation
    log_in_as(user)
    assert_not is_logged_in?
    # Invalid activation token
    get edit_account_activation_path("invalid token")
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, "wrong")
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
