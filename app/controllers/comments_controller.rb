class CommentsController < ApplicationController
  before_action :set_tweet, only: [:index, :edit, :update, :create ]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy, :new, :create]
  before_action only: [:edit, :update, :destroy] do
    authorize_user(@comment.user)
  end

  def index
    @comments = @tweet.comments.order(created_at: :desc)
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to tweet_path(@tweet), notice: "Comment updated successfully" }
      else
        flash[:alert] = @comment.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create
    @comment = @tweet.comments.create(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to tweet_path(@tweet) }
      else
        format.html { redirect_to @tweet, alert: @comment.errors.full_messages }
      end
    end
  end

  def show
    redirect_to tweet_path(Tweet.find(params[:tweet_id]))
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to tweet_path(Tweet.find(params[:tweet_id])) }
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_tweet
      @tweet = Tweet.friendly.find(params[:tweet_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
