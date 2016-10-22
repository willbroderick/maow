class AddCustomRefToDelayedJob < ActiveRecord::Migration
  def change
    change_table :delayed_jobs do |t|
      t.string :custom_reference, null: false, default: ''
    end
  end
end
