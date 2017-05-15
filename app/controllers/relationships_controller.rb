class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def index
    @title = params[:title]
    @user = User.find_by id: params[:user_id]
    if @user
      @users = @user.send(@title).paginate page: params[:page]
      render "users/show_follow"
    else
      flash[:danger] = t "user_not_found"
      redirect_to root_url
    end
  end

  def create
    @user = User.find_by id: params[:followed_id]
    if @user
      current_user.follow @user
      respond_to do |format|
        format.html{redirect_to user_path}
        format.js
      end
      @unfollow = current_user.active_relationships.find_by(
        followed_id: @user.id)
    else
      flash[:error] = t "user_not_found"
      redirect_to root_path
    end
  end

  def destroy
    @user = Relationship.find_by(params[:id]).followed
    current_user.unfollow @user
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
    @follow = current_user.active_relationships.build
  end
end
