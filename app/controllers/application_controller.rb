class ApplicationController < ActionController::Base
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

  def get_last_date
    # the goal is the find the most recent date for which we have data for all the funds
    # we choose the last five days in the data base
    last_dates = Calendar.last(5).reverse
    # we count the number of funds
    number_of_funds = Fund.count
    # for each date we check if the number of funds for whoch we have data == the total number of funds
    last_dates.each do |last_date|
      number_of_fund_for_date = DailyDatum.where(calendar_id: last_date.id).count
      # when the number of DailyDatum for that date == the number of funds then we return the date
      return last_date if number_of_fund_for_date == number_of_funds
    end
  end

  def get_all_daily_data(funds, date)
    # we create an array
    final_data = []
    # for each fund we choose the dailydata that matches the date and the funds
    funds.each do |fund|
      data = DailyDatum.find_by(fund_id: fund.id, calendar_id: date.id)
      # then we create a hash with the data we need
      final_data << { "fund" => fund, "date" => date.day, "share_price" => data.share_price, "aum" => data.aum, "return_daily_value" => data.return_daily_value, "volatility" => data.volatility, "sharpe_ratio" => data.sharpe_ratio, "tracking_error" => data.tracking_error, "return_weekly_value" => data.return_weekly_value, "return_monthly_value" => data.return_monthly_value, "return_quarterly_value" => data.return_quarterly_value, "return_annual_value" => data.return_annual_value, "application_weekly_net_value" => data.application_weekly_net_value, "application_monthly_net_value" => data.application_monthly_net_value, "application_quarterly_net_value" => data.application_quarterly_net_value, "application_annual_net_value" => data.application_annual_net_value }
    end
    # then we send an array of hashes
    final_data
  end
end
