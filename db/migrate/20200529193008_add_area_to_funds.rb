class AddAreaToFunds < ActiveRecord::Migration[5.2]
  def change
    add_reference :funds, :area, foreign_key: true
  end
end
