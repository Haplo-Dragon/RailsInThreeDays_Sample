class SessionsController < ApplicationController

  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user and @user.authenticate(params[:session][:password])
  		# Log user in and create a new session
      log_in(@user)

      # If the session's remember_me attribute (from the checkbox) is set to 1, call
      # remember(user) method. If it's not, call forget(user) method using ternary operator
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)    
      redirect_back_or(@user)
  	else
  		# Create and flash an error message
  		flash.now[:danger] = "Invalid email/password combination"
  		render 'new'
  	end
  end

  def destroy
    if logged_in?
      log_out
    end
    redirect_to root_url
  end

end
