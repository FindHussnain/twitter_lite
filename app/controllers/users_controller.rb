class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :destroy, :show, :update, :follow, :unfollow]
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action only: [:destroy, :edit, :update] do
    authorize_user(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        flash[:notice] = "Welcome to the Twitter Lite #{@user.username}"
        session[:user_id] = @user.id
        format.html { redirect_to tweets_path }
      else
        flash[:alert] = @user.errors.full_messages
        format.html { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @user.update(user_params)
        flash[:notice] = "Your account was updated successfully"
        format.html { redirect_to users_path }
      else
        flash[:alert] = @user.errors.full_messages
        format.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def show
    @pagy, @user_tweets = pagy(@user.tweets.all.order(created_at: :desc), items: 10)
  end

  def index
    # byebug
    if params[:tag] == "followers"
      if logged_in? && current_user.admin?
        @users = User.friendly.find(params[:id]).followers
      else
        @users = User.active.friendly.find(params[:id]).followers
      end
    elsif params[:tag] == "followings"
      if logged_in? && current_user.admin?
        users = User.friendly.find(params[:id]).follows.ids
        users.each_with_index do |id, index|
          users[index] = User.find(id)
        end
        @users = users
      else
        users = User.active.friendly.find(params[:id]).follows.ids
        users.each_with_index do |id, index|
          users[index] = User.find(id)
        end
        @users = users
      end
    else
      if logged_in? && current_user.admin?
        @pagy, @users = pagy(User.all, items: 10)
      else
        @pagy, @users = pagy(User.active, items: 10)
      end
    end
  end

  def destroy
    if current_user.has_role?(:admin) || current_user == @user
      @user.destroy
      redirect_to users_path
    else
      flash[:alert] = "You are not elligible for this"
    end
  end

  def follow
    @current_user.follow(@user)
    @follow = Follow.find_by(follower: @current_user, followable: @user)
    redirect_to request.referer
  end

  def unfollow
    @current_user.stop_following(@user)
    redirect_to request.referer
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :image, {role_ids: []}, :active)
  end

  def set_user
    @user = User.friendly.find(params[:id])
  end
end
