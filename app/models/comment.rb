class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :tweet
  has_rich_text :body
  validates :body, presence: true
  after_create_commit :notify_recipient
  before_destroy :cleanup_notifications
  has_noticed_notifications model_name: 'Notification'
  private
    def notify_recipient
      CommentNotification.with(comment: self, tweet: tweet).deliver_later(tweet.user)
    end

    def cleanup_notifications
      notifications_as_comment.destroy_all
    end
end
