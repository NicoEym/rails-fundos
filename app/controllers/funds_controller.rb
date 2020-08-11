class FundsController < ApplicationController
  require "date"

  def show
    # funds is the fund given by the params
    @fund = Fund.find(params[:id])
    authorize @fund
    @benchmark = @fund.bench_mark

    # we get the last date
    @date = get_last_date(@fund)

    # we will get the lastest registered data
    @this_fund_data = set_fund_data(@fund, @date)

    # now we will work to build the charts
    # We get the history of daily data for the fund we are interested in
    range_data = DailyDatum.where(fund_id: @fund.id)

    # this function will get the competitors of the fund for which we have a data on that day
    @competitors = get_competitors(@fund, @date)

    # we put our fund in an array
    this_fund_array = [@fund]
    # we use a function that is in application controller
    # we get an array of hash with the daily data for the fund
    @this_fund_data_hash = get_all_daily_data(this_fund_array, @date)

    # we use a function that is in application Controller
    # we get an array of hash with the daily data for the fund's competitors
    @competitors_datas_hash = get_all_daily_data(@competitors, @date)

    # then we use the function to get the returns of the competitors
    @chart_monthly_returns_vs_competitors = get_returns_data(@competitors, @fund, @date, "monthly_return")
    @chart_quarterly_returns_vs_competitors = get_returns_data(@competitors, @fund, @date, "quarterly_return")
    # then we use the function to get the risk/return relation of the competitors and the fund
    @chart_risk_returns = get_returns_data(@competitors, @fund, @date, "risk/return")

    # we call a function in the application controller to get the last day of the last 12 months
    end_of_months_dates = get_final_days_of_month

    # for charts that requires end of the month data, we send as parameter the dates of the last 12 months and
    # ... and the historical data for the fund
    # This function will get the history of AUM. The one the history of share price
    @history_aum = get_end_of_month_data_for_charts(range_data, "aum", end_of_months_dates)
    @history_share = get_end_of_month_data_for_charts(range_data, "share_price", end_of_months_dates)
    @history_volatility = get_end_of_month_data_for_charts(range_data, "volatility", end_of_months_dates)
    # We get the monthly captation using the end of month dates
    @chart_monthly_captation = get_end_of_month_data_for_charts(range_data, "monthly_captation", end_of_months_dates)
    # We get the monthly returns vs the benchmark
    @chart_returns_vs_benchmark = get_returns_vs_benchmark(range_data, @fund, @benchmark, end_of_months_dates)

    @chart_incremental_returns = get_incremental_returns_data(@fund, @competitors, @benchmark, end_of_months_dates)
  end

  def index
    # we get the area params
    @area = params[:area_name]
    # if no area params is settled
    @funds = policy_scope(Fund)
    # ... we list all the funds present in the DB
    # ... we show only the funds that match the area
    @area.nil? ? @funds = @funds.all : @funds = @funds.where(area_name: params[:area_name])
  end

  def get_end_of_month_data_for_charts(datas, data_type, dates_12_months)
    # for end of month dates, we get the date and the AUM/share_price/volatility value for the fund.
    # Doing so we have our historical serie of data for the AUM
    historical_array = []
    dates_12_months.each do |date|
      data_of_the_day = datas.find_by(calendar: date)
      case data_type
        when "aum" then
          historical_array << [data_of_the_day.calendar.day, data_of_the_day.aum / 1_000_000_000] unless data_of_the_day.aum.nil?
        when "share_price" then
          historical_array << [data_of_the_day.calendar.day, data_of_the_day.share_price] unless data_of_the_day.share_price.nil?
        when "volatility" then
          historical_array << [data_of_the_day.calendar.day, data_of_the_day.volatility] unless data_of_the_day.volatility.nil?
        when "monthly_captation" then
          historical_array << [data_of_the_day.calendar.day, data_of_the_day.application_monthly_net_value / 1_000_000] unless data_of_the_day.application_monthly_net_value.nil?
      end
    end
    historical_array.sort_by()
  end

  def get_competitors(fund, date)
    competitors = []
    # if we do not have a short name, the fund is not from Indosuez, then we display only the indosuez fund as a competitor.
    # if we have a shortname, the fund is from Indosuez and then we display all the fund that belongs to this group
    fund.short_name.nil? ? competitors = Fund.where(short_name: fund.competitor_group) : competitors = Fund.where(competitor_group: fund.short_name)
    # then we will exclude the competitors that does not have data for the specific date
    filtered_competitors = []
    competitors.each do |competitor|
      filtered_competitors << competitor unless set_fund_data(competitor, date).nil?
    end
    filtered_competitors
  end

  def get_returns_data(competitors, fund, date, data_type)
    historical_array = []
    # depending on the type of return specified we will send either the monthly return, either...
    # ... either the couple risk/return
    case data_type
      when "monthly_return"
        # we loop on each competitor to include their monthly return on the array
        competitors.each do |competitor|
          historical_array << get_monthly_return(competitor, date)
        end
        # then we include the monthly data of the fund
        historical_array << get_monthly_return(fund, date)


      when "quarterly_return"
        # we loop on each competitor to include their monthly return on the array
        competitors.each do |competitor|
          historical_array << get_quarterly_return(competitor, date)
        end
        # then we include the monthly data of the fund
        historical_array << get_quarterly_return(fund, date)

      when "risk/return"
        # we loop on each competitor to include their couple risk/return on the array
        competitors.each do |competitor|
          historical_array << get_risk_return(competitor, date)
        end
        # then we include the couple risk/return of the fund
        historical_array << get_risk_return(fund, date)
    end
    historical_array
  end

  # quick method to get the monthly return of a fund in an array ready to display on a chart
  def get_monthly_return(fund, date)
    fund_data = set_fund_data(fund, date)
    [fund.best_name, fund_data.return_monthly_value.round(2)] unless fund_data.nil?
  end

  def get_quarterly_return(fund, date)
    fund_data = set_fund_data(fund, date)
    [fund.best_name, fund_data.return_quarterly_value.round(2)] unless fund_data.nil?
  end

  # quick method to get the risk/return of a fund in a hash ready for the chart
  def get_risk_return(fund, date)
    fund_data = set_fund_data(fund, date)
    { name: fund.best_name, data: { fund_data.volatility.round(2) => fund_data.return_annual_value.round(2) } } unless fund_data.nil?
  end

  def get_returns_vs_benchmark(datas, fund, benchmark, dates)
    # we create several arrays
    historical_array = []
    fund_data_array = []
    benchmark_data_array = []

    # for each end of month date we insert in an array the corresponding DailyDatum
    # we do this for the fund and the Benchmark
    dates.each do |date|
      fund_data = datas.find_by(calendar: date)
      fund_data_array << fund_data unless fund_data.nil?
      benchmark_data = DataBenchmark.find_by(bench_mark: benchmark, calendar: date)
      benchmark_data_array << benchmark_data unless benchmark_data.nil?
    end
    # then we create the hash to be inserted in the final array for the graph
    historical_array << { name: fund.best_name, data: fund_data_array.map {|t| [t.calendar.day.strftime("%Y-%m"), t.return_monthly_value.round(2)] } }
    historical_array << { name: benchmark.name, data: benchmark_data_array.map {|t| [t.calendar.day.strftime("%Y-%m"), t.return_monthly_value.round(2)] } }
  end

  def get_incremental_returns_data(fund, competitors, benchmark, dates_12_months)
    # we create the array that will receive our final data
    historical_array = []

    # we create an array with every object (funds and benchmark)
    assets = [fund, benchmark]
    competitors.each do |competitor|
      assets << competitor
    end

    # we loop this assets
    assets.each do |asset|
      # we create the array where we will stock our data
      asset_array = []
      # we initiate the index to 100
      indice = 100
      # we put the starting month and the indice value in an hash that we store in an array
      asset_array << { date: dates_12_months[0].day, data: indice }
      # we take out the first date, we already used it
      dates = dates_12_months.drop(1)

      # we call a function that will run the calculation of the incremental return
      final_asset_data_array = calculate_incremental_returns(dates, asset, indice, asset_array)

      # we insert the data in the final array and we map the historical data for the chart
      historical_array << { name: asset.name, data: final_asset_data_array.map { |t| [t[:date].strftime("%Y-%m"), t[:data]] } }
    end

    # we return the final array(of hashes, for each asset) with the historical data for every assets
    historical_array
  end

  def calculate_incremental_returns(dates, asset, price, final_data_array)
    # for each dates, we will check if the asset is a fund or a benchmark.
    # Depending on this we look in the correct database table

    if asset.is_a?(BenchMark)
      asset_data = DataBenchmark.where(bench_mark: asset)
    elsif asset.is_a?(Fund)
      asset_data = DailyDatum.where(fund: asset)
    end

    dates.each do |date|
      data_array = asset_data.find_by(calendar: date)
      # we increment our price with the monthly return
      price = (1 + data_array.return_monthly_value / 100) * price unless data_array.nil?
      # we store the data in the array
      final_data_array << { date: date.day, data: price } unless data_array.nil?
    end
    # we return the data for the asset
    final_data_array
  end

  private

  def set_fund_data(fund, date)
    DailyDatum.find_by(fund: fund, calendar: date)
  end
end
