class AddGraphGenerationTime < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.datetime :graph_generated_at, null: false, default: (DateTime.now - 1.year)
    end
  end
end
