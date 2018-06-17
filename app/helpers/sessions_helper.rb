module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def remember user
    user.remember
    cookies_permanent.signed[:user_id] = user.id
    cookies_permanent[:remember_token] = user.remember_token
  end

  def current_user
    if sessiontmp
      @current_user ||= User.find_by id: sessiontmp
    elsif user_id = cookies.signed[:user_id]
      user = User.find_by id: user_id
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget current_user
    @current_user = nil
    session.delete(:user_id)
  end

  private

  def cookies_permanent
    cookies.permanent
  end

  def sessiontmp
    session[:user_id]
  end

  def forget user
    user.forget
    cookies.delete :user_id
    cookies.delete :remember_token
  end
end
