class AddIndexToEntities < ActiveRecord::Migration
  def change
    change_table :entities do |t|
      t.index :entity
      t.boolean :is_compound, null: false, default: false
    end
  end
end
