class DropIndicator < ActiveRecord::Migration[5.2]
  def change
    drop_table :indicators
  end
end
