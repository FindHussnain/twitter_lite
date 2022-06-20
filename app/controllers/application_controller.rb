class ApplicationController < ActionController::Base
  include Pagy::Backend
  Pagy::DEFAULT[:items]  = 10
  before_action :set_notifications if :current_user
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def authenticate_user
    if !logged_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: "You are not elligible for this action, signin first!" }
      end
    end
  end

  def authorize_user(user)
    if user != current_user && !current_user.admin?
      respond_to do |format|
        format.html { redirect_to tweets_path, alert: "You are not elligible, signin with authorize account" }
      end
    end
  end

  def set_notifications
    @notifications = Notification.where(recipient: current_user).newest_first.limit(9)
    @unread = @notifications.unread
    @read = @notifications.read
  end

  def authenticate_admin
    if !current_user.admin?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "You are not elligible, signin with authorize account" }
      end
    end
  end

  def authenticate_subscription
    if !current_user.user_subscriptions.any?
      respond_to do |format|
        format.html { redirect_to subscriptions_path, alert: "Select a subscription"}
      end
    end
  end

  # def find_trending_tags
  #   @tags = Tweet.tag_list
  #   @tagCount = @tags.maximum(:taggings_count)
  #   @tag = @tags.find_by(taggings_count: @tagCount)
  # end

end
