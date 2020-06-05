class FixColumnName < ActiveRecord::Migration[5.2]
  def change

    rename_column :indicators, :sharpe_ration, :sharpe_ratio

  end
end
