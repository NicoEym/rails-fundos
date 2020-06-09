class RenameRetornoCdiToFunds < ActiveRecord::Migration[5.2]
  def change
    rename_column :daily_data, :return_over_CDI_daily_value, :return_over_benchmark_daily_value
    rename_column :daily_data, :return_over_CDI_weekly_value, :return_over_benchmark_weekly_value
    rename_column :daily_data, :return_over_CDI_monthly_value, :return_over_benchmark_monthly_value
    rename_column :daily_data, :return_over_CDI_quarterly_value, :return_over_benchmark_quarterly_value
    rename_column :daily_data, :return_over_CDI_annual_value, :return_over_benchmark_annual_value
  end
end
