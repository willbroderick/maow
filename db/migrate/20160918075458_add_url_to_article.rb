class AddUrlToArticle < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.string :url
      t.text :raw
    end
  end
end
