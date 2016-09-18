class AddSvgBgToSources < ActiveRecord::Migration
  def change
    change_table :sources do |t|
      t.string :svg_bg
    end
  end
end
