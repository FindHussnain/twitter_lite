class CommentsController < ApplicationController
  before_action :set_article, only: [:index, :edit, :update, :create ]
  before_action :set_comment, only: [:edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy, :new, :create]
  before_action only: [:edit, :update, :destroy] do
    authorize_user(@comment.user)
  end

  def index
    @comments = @article.comments
  end

  def edit; end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to article_path(@article), notice: "Comment updated successfully" }
      else
        flash[:alert] = @comment.errors.full_messages
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def create
    @comment = @article.comments.create(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path(@article) }
      else
        format.html { redirect_to @article, alert: @comment.errors.full_messages }
      end
    end
  end

  def show
    redirect_to article_path(Article.find(params[:article_id]))
  end

  def destroy
    respond_to do |format|
      if @comment.destroy
        format.html { redirect_to article_path(Article.find(params[:article_id])) }
      end
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:body)
    end

    def set_article
      @article = Article.find(params[:article_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end
