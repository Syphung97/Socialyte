class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: session_params[:email].downcase)
    if user && user.authenticate(session_params[:password])
      log_in user
      remember user if session_params[:remember_me] == "1"
      redirect_to user
    else
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private
  def session_params
    params[:session]
  end

end
