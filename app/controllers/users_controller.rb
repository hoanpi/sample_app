class UsersController < ApplicationController
  before_action :logged_in_user, except: [:new, :create, :show]
  before_action :admin_user, only: :destroy
  before_action :find_user, except: [:index, :new, :create]
  before_action :correct_user,   only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "welcome"
      redirect_to user_path @user
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "updated" 
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    User.find(params[:id]).destroy
    flash[:success] = t "user_del"
    redirect_to users_url
  end

  private
  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "please_login"
      redirect_to login_url
    end
  end

  def admin_user
    redirect_to root_path unless current_user.admin?
  end

  def correct_user
    redirect_to root_path unless @user.current_user? current_user
  end

  def find_user
    @user = User.find_by id: params[:id]
    unless @user
      flash[:error] = t "error"
      redirect_to root_path
    end
  end

end
