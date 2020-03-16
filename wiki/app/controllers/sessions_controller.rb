class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    p_params = permit_create_params
    @user = User.where(name: p_params[:name], password: p_params[:password]).first
    if @user
      set_user_session @user
      redirect_to root_path and return
    else
      @user = User.new(p_params)
      @user.errors[:base] << 'Faild authentication. Please confirm name and password.'
      render :new and return
    end
  end

  def delete
    session.delete(:user_id)
    session.delete(:name)
    redirect_to login_path and return
  end

  private
  def permit_create_params
    params.require(:user).permit(:name, :password)
  end
end
