class DropShare < ActiveRecord::Migration[5.2]
  def change
    drop_table :shares
  end
end
