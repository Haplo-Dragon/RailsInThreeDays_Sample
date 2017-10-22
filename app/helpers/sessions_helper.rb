module SessionsHelper

	def log_in(user)
		session[:user_id] = user.id		
	end

	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)		
	end

	def log_out
		forget(current_user)		
		session.delete(:user_id)
		@current_user = nil		
	end

	# Returns true if the given user is the current user
	def current_user?(user)
		user == current_user
	end

	# Returns the user corresponding to the remember token cookie
	def current_user
		if (user_id = session[:user_id]) # if statemtent tests an ASSIGNMENT, not a conditional
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id]) # if statemtent tests assignment again			
			user = User.find_by(id: user_id)
			if user and user.authenticated?(:remember, cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end		
	end

	def logged_in?
		!current_user.nil?
	end

	def store_location
		session[:forwarding_url] = request.original_url if request.get?			
	end
	
	def redirect_back_or(default)		
		redirect_to(session[:forwarding_url] || default)		
		session.delete(:forwarding_url)		
	end

end
