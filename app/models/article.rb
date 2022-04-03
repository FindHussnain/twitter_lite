class Article < ApplicationRecord
  belongs_to :user
  acts_as_taggable_on :tags
  acts_as_votable
  # acts_as_taggable_on :programming, :development, :ruby
  has_many :comments, dependent: :destroy
  validates :title, presence: true, length: {minimum: 5, maxmum: 100}
  validates :description, presence: true, length: {minimum: 5}
  validates :user_id, presence: true
  has_noticed_notifications model_name: 'Notification'
  has_many :notifications, through: :user, dependent: :destroy
end
