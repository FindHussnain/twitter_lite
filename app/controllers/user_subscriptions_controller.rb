class UserSubscriptionsController < ApplicationController
  def create
    @user_subscription = current_user.user_subscriptions.new(subscription_id: params[:subscription_id])
    respond_to do |format|
      @user_subscription.save
      format.html { redirect_to root_path, notice: "You have purchased successfully" }
    end
  end
end
