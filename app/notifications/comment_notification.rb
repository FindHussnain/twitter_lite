# To deliver this notification:
#
# CommentNotification.with(post: @post).deliver_later(current_user)
# CommentNotification.with(post: @post).deliver(current_user)

class CommentNotification < Noticed::Base
  # Add your delivery methods
  #
  deliver_by :database
  # deliver_by :email, mailer: "UserMailer"
  # deliver_by :slack
  # deliver_by :custom, class: "MyDeliveryMethod"

  # Add required params
  #
  # param :post

  # Define helper methods to make rendering easier.
  #
  def message
    @tweet = Tweet.find(params[:comment][:tweet_id])
    @comment = Comment.find(params[:comment][:id])
    @user = User.find(@comment.user_id)
    return "#{@user.email} commented on #{@tweet.title.truncate(10)}"
  end

  def url
    tweet_path(Tweet.find(params[:comment][:tweet_id]))
  end
end
