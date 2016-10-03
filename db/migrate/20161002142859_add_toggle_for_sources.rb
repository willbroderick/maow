class AddToggleForSources < ActiveRecord::Migration
  def change
    change_table :sources do |t|
      t.boolean :enabled, null: false, default: true
    end
  end
end
