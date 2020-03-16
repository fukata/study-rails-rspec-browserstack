class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.create!(permit_create_params)
    set_user_session @user
    redirect_to root_path and return
  rescue ActiveRecord::RecordInvalid => e
    @user = e.record
    render :new and return
  end

  private
  def permit_create_params
    params.require(:user).permit(:name, :password)
  end
end
