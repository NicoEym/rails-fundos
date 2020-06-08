class DropReturn < ActiveRecord::Migration[5.2]
  def change
    drop_table :returns
  end
end
