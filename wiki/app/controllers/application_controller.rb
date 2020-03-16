class ApplicationController < ActionController::Base
  before_action :set_current_user

  helper_method :current_user

  def required_login
    unless current_user
      redirect_to login_path and return
    end
  end

  def current_user
    @current_user ||= set_current_user
  end

  def set_current_user
    if session[:user_id]
      @current_user ||= User.find_by(id: session[:user_id].to_i)
    end
  end

  def set_user_session(user)
    session[:user_id] = user.id
    session[:name] = user.name
  end
end
