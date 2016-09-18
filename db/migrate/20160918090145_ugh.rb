class Ugh < ActiveRecord::Migration
  def change
    change_table :articles do |t|
      t.rename :published, :published_at
    end
  end
end
