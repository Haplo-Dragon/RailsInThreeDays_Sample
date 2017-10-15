require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  
	def setup
		@user = users(:michael)  	
	end

	test "invalid login" do
		get login_path
		assert_template 'sessions/new'

		invalid_params = { session: { email: "", password: "" } }
		post login_path, params: invalid_params
		assert_template 'sessions/new'
		assert_not flash.empty?

		get root_path
		assert flash.empty?
	end

	test "login with valid info followed by logout" do	
	  	get login_path
	  	post login_path, params: { session: { 	email: 		@user.email,
	  											password: 	'password'}}
	  	assert is_logged_in?
	  	assert_redirected_to @user
	  	follow_redirect!	  	

	  	assert_template 'users/show'
	  	assert_select "a[href=?]", login_path, count: 0
	  	assert_select "a[href=?]", logout_path
	  	assert_select "a[href=?]", user_path(@user)

	  	# Logout
	  	delete logout_path
	  	assert_not is_logged_in?
	  	assert_redirected_to root_url
	  	follow_redirect!

	  	assert_select "a[href=?]", login_path
	  	assert_select "a[href=?]", logout_path, 	  count: 0
	  	assert_select "a[href=?]", user_path(@user),  count: 0
	end

end
