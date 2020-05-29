class AddAnbimaClassToFunds < ActiveRecord::Migration[5.2]
  def change
    add_reference :funds, :anbima_class, foreign_key: true
  end
end
