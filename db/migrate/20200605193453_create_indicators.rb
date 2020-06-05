class CreateIndicators < ActiveRecord::Migration[5.2]
  def change
    create_table :indicators do |t|
      t.references :fund, foreign_key: true
      t.references :calendar, foreign_key: true
      t.float :volatility
      t.float :tracking_error
      t.float :sharpe_ration

      t.timestamps
    end
  end
end
