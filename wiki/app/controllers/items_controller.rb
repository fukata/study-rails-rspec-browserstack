class ItemsController < ApplicationController
  before_action :required_login

  def index
    @items = current_user.items.order('id desc')
  end

  def new
    @item = Item.new
  end

  def create
    @item = Item.create!(permit_create_params)
    redirect_to items_path and return
  rescue ActiveRecord::RecordInvalid => e
    @item = e.record
    render :new and return
  end

  private
  def permit_create_params
    params.require(:item).permit(:title, :content, :user_id)
  end
end
