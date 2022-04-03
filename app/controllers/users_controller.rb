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
        format.html { redirect_to articles_path }
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
        format.html { redirect_to articles_path }
      else
        flash[:alert] = @user.errors.full_messages
        format.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def show
    @pagy, @user_articles = pagy(@user.articles.all)
  end

  def index
    @pagy, @users = pagy(User.all)
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
    params.require(:user).permit(:username, :email, :password, {role_ids: []})
  end

  def set_user
    @user = User.find(params[:id])
  end
end
