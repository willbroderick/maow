class AddImportanceToEntities < ActiveRecord::Migration
  def change
    change_table :entities do |t|
      t.integer :importance, null: false, default: 0
    end
  end
end
