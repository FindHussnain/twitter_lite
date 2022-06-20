class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: [:edit, :show, :update, :destroy]
  before_action :authenticate_user, only:[:new, :create, :edit, :update, :destroy]
  before_action :authenticate_admin, only:[:new, :create, :edit, :update, :destroy]

  def new
    @subscription = Subscription.new
  end

  def create
    @subscription = Subscription.new(subscription_params)
    respond_to do |format|
      if @subscription.save
        format.html { redirect_to subscription_path(@subscription), notice: "subscription was successfully created!" }
      else
        flash[:alert] = @subscription.errors.full_messages
        format.html { render 'new', status: :unprocessable_entity }
      end
    end

  end

  def show;  end

  def edit;  end

  def update
    respond_to do |format|
      if @subscription.update(subscription_params)
        format.html { redirect_to subscription_path(@subscription), notice: "subscription updated successfully" }
      else
        flash[:alert] = @subscription.errors.full_messages
        format.html { render 'edit', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      @subscription.destroy
      format.html { redirect_to subscriptions_path, notice: "subscription deleted successfully" }
    end
  end

  def index
    @subscriptions = Subscription.all
  end

private

  def set_subscription
    @subscription = Subscription.find(params[:id])
  end

  def subscription_params
    params.require(:subscription).permit(:name, :description, :price, :active, :subscription_type, :number_of_tweets)
  end
end
