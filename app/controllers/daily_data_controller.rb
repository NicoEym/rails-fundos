class DailyDataController < ApplicationController
  def index
    # we display data only for Indosuez funds
    gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
    @funds = Fund.where(gestor: gestor)
    @daily_data = policy_scope(DailyDatum)
    @datas = get_last_daily_data(@funds, @daily_data)
  end

  def get_last_daily_data(funds, daily_data)
    # we create an array
    final_data = []
    # for each fund we choose the dailydata that matches the funds
    funds.each do |fund|
      date = get_last_date(fund)
      data = daily_data.find_by(fund: fund, calendar: date)

      # then we create a hash with the data we need
      final_data << { "fund" => fund, "date" => data.calendar.day,
                      "share_price" => data.share_price,
                      "aum" => data.aum, "return_daily_value" => data.return_daily_value,
                      "volatility" => data.volatility, "sharpe_ratio" => data.sharpe_ratio,
                      "tracking_error" => data.tracking_error,
                      "return_weekly_value" => data.return_weekly_value,
                      "return_monthly_value" => data.return_monthly_value,
                      "return_quarterly_value" => data.return_quarterly_value,
                      "return_annual_value" => data.return_annual_value,
                      "return_over_benchmark_daily_value" => data.return_over_benchmark_daily_value,
                      "return_over_benchmark_weekly_value" => data.return_over_benchmark_weekly_value,
                      "return_over_benchmark_monthly_value" => data.return_over_benchmark_monthly_value,
                      "return_over_benchmark_quarterly_value" => data.return_over_benchmark_quarterly_value,
                      "return_over_benchmark_annual_value" => data.return_over_benchmark_annual_value,
                      "application_weekly_net_value" => data.application_weekly_net_value,
                      "application_monthly_net_value" => data.application_monthly_net_value,
                      "application_quarterly_net_value" => data.application_quarterly_net_value,
                      "application_annual_net_value" => data.application_annual_net_value }
    end
    # then we send an array of hashes
    final_data
  end
end
