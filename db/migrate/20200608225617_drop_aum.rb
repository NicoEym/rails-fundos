class DropAum < ActiveRecord::Migration[5.2]
  def change
    drop_table :aums
  end
end
