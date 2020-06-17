class ApplicationController < ActionController::Base
  require 'date'

  before_action :authenticate_user!
  before_action :navbar

  def navbar
    @areas = []
    @areas << Area.find_by(name: "Crédito Privado")
    @areas << Area.find_by(name: "FOFs")
  end

  def after_sign_up_path_for(resource)
    "/areas/"# <- Path you want to redirect the user to.
  end

  def after_sign_in_path_for(resource)
    "/areas/"# <- Path you want to redirect the user to.
  end

  def get_last_date(fund)
    # the goal is the find the most recent date for which the fund has data
    # we choose the last five days in the data base
    today = Date.today
    last_dates = []
    (1..10).each do |d|
      previous_day = today - d
      existing_date = Calendar.find_by(day: previous_day)
      last_dates << existing_date unless existing_date.nil?
    end

    # for each date we check if the fund has data
    last_dates.each do |last_date|
      data = DailyDatum.find_by(fund_id: fund, calendar_id: last_date.id)
      # when the number of DailyDatum for that date == the number of funds then we return the date
      return last_date if !data.nil?
    end
  end

  def get_all_daily_data(funds, date)
    # we create an array
    final_data = []
    # for each fund we choose the dailydata that matches the date and the funds
    funds.each do |fund|
      data = DailyDatum.find_by(fund_id: fund.id, calendar_id: date.id)
      # then we create a hash with the data we need
      final_data << { "fund" => fund, "date" => date.day,
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

    def get_final_days_of_month
    # we create an array
    last_day_of_months = []
    # for each fund we choose the dailydata that matches the date and the funds
    dates = Calendar.order('day desc')

    dates.each do |date|
      last_day_of_months << date if date.last_day_of_month? && last_day_of_months.size < 12
    end
    # then we send an array of dates
    last_day_of_months.sort
  end
end
