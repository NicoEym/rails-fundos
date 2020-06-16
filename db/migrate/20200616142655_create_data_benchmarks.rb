class CreateDataBenchmarks < ActiveRecord::Migration[5.2]
  def change
    create_table :data_benchmarks do |t|
      t.references :bench_mark, foreign_key: true
      t.references :calendar, foreign_key: true
      t.float :return_daily_value
      t.float :return_weekly_value
      t.float :return_monthly_value
      t.float :return_quarterly_value
      t.float :return_annual_value
      t.float :volatility
      t.float :daily_value

      t.timestamps
    end
  end
end
