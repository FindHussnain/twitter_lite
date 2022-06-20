class Subscription < ApplicationRecord
  enum subscription_type: [:basic, :standard, :platinum]
  has_many :user_subscriptions, dependent: :destroy
  validates :name, presence: true
  validates :description, presence: true
  validates :subscription_type, presence: true
  validates :active, presence: true
  validates :number_of_tweets, presence: true
end
