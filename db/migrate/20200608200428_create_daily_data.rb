class CreateDailyData < ActiveRecord::Migration[5.2]
  def change
    create_table :daily_data do |t|
      t.float :aum
      t.float :share_price
      t.float :return_daily_value
      t.float :return_weekly_value
      t.float :return_monthly_value
      t.float :return_quarterly_value
      t.float :return_annual_value
      t.float :application_daily_net_value
      t.float :application_weekly_net_value
      t.float :application_monthly_net_value
      t.float :application_quarterly_net_value
      t.float :application_annual_net_value
      t.float :return_over_CDI_daily_value
      t.float :return_over_CDI_weekly_value
      t.float :return_over_CDI_monthly_value
      t.float :return_over_CDI_quarterly_value
      t.float :return_over_CDI_annual_value
      t.float :volatility
      t.float :tracking_error
      t.float :sharpe_ratio
      t.references :fund, foreign_key: true
      t.references :calendar, foreign_key: true

      t.timestamps
    end
  end
end
