class AddValueTypesToTopiCRules < ActiveRecord::Migration
  def change
    change_table :topic_rules do |t|
      t.remove :value
      t.integer :value_integer
      t.datetime :value_datetime
      t.string :value_string
    end
  end
end
