class TweetsController < ApplicationController
  before_action :set_tweet, only: [:edit, :show, :update, :destroy, :like]
  before_action :authenticate_user, only:[:new, :create, :edit, :update, :destroy, :like]
  before_action only: [:edit, :update, :destroy] do
    authorize_user(@tweet.user)
  end
  before_action :authenticate_subscription, only: [:new, :create]

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(tweet_params)
    respond_to do |format|
      if @tweet.save
        format.html { redirect_to tweet_path(@tweet), notice: "tweet was successfully created!" }
      else
        flash[:alert] = @tweet.errors.full_messages
        format.html { render 'new', status: :unprocessable_entity }
      end
    end
  end

  def show
    @comment = Comment.new
    @comments = @tweet.comments.includes(:user)
    mark_notifications_as_read
  end

  def edit; end

  def update
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.html { redirect_to tweet_path(@tweet), notice: "tweet was updated!" }
      else
        flash[:alert] = @tweet.errors.full_messages
        format.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def index
    if params[:tag]
      @pagy, @tweets = pagy(Tweet.tagged_with(params[:tag]), items: 10)
      @tweets = @tweets.order(created_at: :desc)
    else
      @pagy, @tweets = pagy(Tweet.all.order(created_at: :desc), items: 10)
    end
  end

  def destroy
    respond_to do |format|
      @tweet.destroy
      format.html { redirect_to tweets_path, notice: "Tweet was deleted" }
    end
  end

  def like
    respond_to do |format|
      if current_user.voted_for? @tweet
        @tweet.unliked_by current_user
      else
        @tweet.liked_by current_user
      end
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:title, :description, :user_id, :tag_list)
  end

  def set_tweet
    @tweet = Tweet.friendly.find(params[:id])
  end

  def mark_notifications_as_read
    if current_user
     notifications_to_mark_as_read = @tweet.notifications_as_tweet.where(recipient: current_user)
      notifications_to_mark_as_read.update_all(read_at: Time.zone.now)
    end
  end
end
