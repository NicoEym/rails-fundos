class AddGestorToFunds < ActiveRecord::Migration[5.2]
  def change
    add_reference :funds, :gestor, foreign_key: true
  end
end
