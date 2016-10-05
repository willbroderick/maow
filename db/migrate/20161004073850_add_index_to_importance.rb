class AddIndexToImportance < ActiveRecord::Migration
  def change
    change_table :entities do |t|
      t.index :importance
    end
  end
end
