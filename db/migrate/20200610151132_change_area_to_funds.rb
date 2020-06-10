class ChangeAreaToFunds < ActiveRecord::Migration[5.2]
  def change
    remove_column :funds, :area_id
    add_column :funds, :area_name, :string
  end
end
