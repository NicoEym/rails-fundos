class DropApplication < ActiveRecord::Migration[5.2]
  def change
    drop_table :applications
  end
end
