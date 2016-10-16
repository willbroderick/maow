class CreateArticleClosenessTable < ActiveRecord::Migration
  def change
    create_table :article_graph_vertices do |t|
      t.integer :article_1_id, null: false
      t.integer :article_2_id, null: false
      t.float :weight, null: false

      t.index :article_1_id
      t.index :article_2_id
    end

    add_foreign_key :article_graph_vertices, :articles, column: :article_1_id
    add_foreign_key :article_graph_vertices, :articles, column: :article_2_id
  end
end
