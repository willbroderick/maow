class AddCreatedTimeToArticles < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.datetime :created_at, null: false, default: DateTime.current
    end
  end
end
