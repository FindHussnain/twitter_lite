class CreateSubscription < ActiveRecord::Migration[7.0]
  def change
    create_table :subscriptions do |t|
      t.string :name
      t.text :description
      t.boolean :active
      t.float :price
      t.integer :subscription_type
      t.integer :number_of_tweets
      t.timestamps
    end
  end
end
