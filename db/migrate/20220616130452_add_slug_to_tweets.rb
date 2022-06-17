class AddSlugToTweets < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :slug, :string
    add_index :tweets, :slug, unique: true
  end
end
