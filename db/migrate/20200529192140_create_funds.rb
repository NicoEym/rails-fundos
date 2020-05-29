class CreateFunds < ActiveRecord::Migration[5.2]
  def change
    create_table :funds do |t|
      t.string :name
      t.string :short_name
      t.integer :codigo_economatica

      t.timestamps
    end
  end
end
