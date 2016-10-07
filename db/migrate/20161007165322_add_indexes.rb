class AddIndexes < ActiveRecord::Migration
  def change
    change_table :article_entities do |t|
      t.index :article_id
      t.index :entity_id
    end

    change_table :articles do |t|
      t.index :source_id
    end

    change_table :entities do |t|
      t.index :industry_id
    end
  end
end
