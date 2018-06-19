class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def new
    @user = User.new
    @genders = User.genders
  end

  def show
    @micropost = current_user.microposts.build if logged_in?
    @microposts = user.microposts.paginate(page: params[:page]).desc
    @supports = Supports::User.new user: user, current_user: current_user
  end

  def create
    @user = User.new(user_params)
    if user.save
      log_in user
      redirect_to user
    else
      render :new
    end
  end
  private

  attr_reader :user

  def user_params
    params.require(:user).permit(:name,:email,:password,:password_confirmation,:gender,:profile_img)
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if user
    flash[:danger] = t "users.show.error"
    redirect_to root_path
  end

end
