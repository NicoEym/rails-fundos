class FundsController < ApplicationController
  require "date"

  def show
    # funds is the fund given by the params
    @fund = Fund.find(params[:id])

    # we get the last date
    @date = get_last_date(@fund)

    # we will get the lastest registered data
    @this_fund_data = DailyDatum.find_by(fund_id: @fund.id, calendar_id: @date.id)

    # now we will work to build the charts
    # We get the history of daily data for the fund we are interested in
    range_data = DailyDatum.where(fund_id: @fund.id)
    # This function will get the history of AUM. The one the history of share price
    @history_aum = get_historical_aum(range_data, 1_000_000_000)
    @history_share = get_historical_share_price(range_data)
    @history_volatility = get_historical_volatility(range_data)

    # this function will get the competitors of the fund
    @competitors = get_competitors(@fund)
    @filtered_competitors = filter(@competitors, @date)

    # we get an array of hash with the daily data for the fund
    array = []
    array << @fund
    # we use a function that is in application controller
    @this_fund_data_hash = get_all_daily_data(array, @date)

    # we get an array of hash with the daily data for the fund's competitors
    @competitors_datas_hash = get_all_daily_data(@filtered_competitors, @date)

    # then we use the function to get the returns of the competitors
    @chart_returns_vs_competitors = get_returns_data(@filtered_competitors, @fund, @date)
    # then we use the function to get the risk/return relation of the competitors and the fund
    @chart_risk_returns = get_risk_returns_data(@filtered_competitors, @fund, @date)

    # we call a function in the application controller to get the last day of the last 12 months
    end_of_months_dates = get_final_days_of_month

    # for charts that requires end of the month data, we send as parameter the dates of the last 12 months and
    # ... and the historical data for the fund
    # We get the monthly captation
    @chart_monthly_captation = get_monthly_captation(range_data, end_of_months_dates)

    # We get the monthly returns vs the benchmark
    @chart_returns_vs_benchmark = get_returns_vs_benchmark(range_data, @fund, end_of_months_dates)
  end

  def index
    # if no area params is settled...
    @area = params[:area_name]
    # ... we list all the funds present in the DB
    if @area.nil?
      @funds = Fund.all
    else
      # ... we show only the funds that match the area
      @funds = Fund.where(area_name: params[:area_name])

    end
  end

  def get_historical_aum(datas, divide = 1)
    # for all the daily data, we get the date and the AUM value for the fund.
    # Doing so we have our historical serie of data for the AUM
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.aum / divide] if !data.aum.nil?
    end

    historical_array
  end

  def get_historical_share_price(datas)
    # for all the daily data, we get the date and the share price value for the fund.
    # Doing so we have our historical serie of data for the share price
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.share_price] if !data.share_price.nil?
    end

    historical_array
  end

  def get_historical_volatility(datas)
    # for all the daily data, we get the date and the AUM value for the fund.
    # Doing so we have our historical serie of data for the AUM
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.volatility] unless data.volatility.nil?
    end

    historical_array
  end

  def get_competitors(fund)
    # if we do not have a short name, the fund is not from Indosuez, then we display only the indosuez fund as a competitor.
    if fund.short_name.nil?
      Fund.where(short_name: fund.competitor_group)
    else
    # if we have a shortname, the fund is from Indosuez and then we display all the fund that belongs to this group
      Fund.where(competitor_group: fund.short_name)
    end
  end

  def filter(competitors, date)
    # if we do not have a short name, the fund is not from Indosuez, then we display only the indosuez fund as a competitor.
    filtered_competitors = []
    competitors.each do |competitor|
      filtered_competitors << competitor unless DailyDatum.find_by(fund: competitor, calendar: date).nil?
    end
    filtered_competitors
  end

  def get_returns_data(competitors, fund, date)
    data = []
    # for each competitor we store the name and the value of the monthly return
    competitors.each do |competitor|
      competitor_data = DailyDatum.find_by(fund_id: competitor.id, calendar_id: date.id)
      data << [competitor.best_name, competitor_data.return_monthly_value.round(2)]
    end
    # Eventually we do the same for our Indosuez fund
    fund_data = DailyDatum.find_by(fund_id: fund.id, calendar_id: date.id)
    data << [fund.best_name, fund_data.return_monthly_value.round(2)]
  end

  def get_risk_returns_data(competitors, fund, date)
    data = []
    # for each competitor we store the name and the couple volatility (x axis) / return (y axis)
    competitors.each do |competitor|
      competitor_data = DailyDatum.find_by(fund_id: competitor.id, calendar_id: date.id)
      data << { name: competitor.best_name, data: { competitor_data.volatility.round(2) => competitor_data.return_annual_value.round(2) } }
    end
    # eventually we do the same for the our Indosuez fund
    fund_data = DailyDatum.find_by(fund_id: fund.id, calendar: date)
    data << { name: fund.best_name, data: { fund_data.volatility.round(2) => fund_data.return_annual_value.round(2) } }
  end

  def get_monthly_captation(datas, dates)
    # for all the end of the month date we will get the monthly captation

    historical_array = []
    dates.each do |date|
      data = datas.find_by(calendar: date)
      historical_array << [date.day.strftime("%Y-%m"), data.application_monthly_net_value / 1_000_000] unless data.nil?
    end
    historical_array
  end

  def get_returns_vs_benchmark(datas, fund, dates)
    # we create several arrays
    historical_array = []
    fund_data_array = []
    benchmark_data_array = []

    # we get the benchmark
    benchmark = fund.bench_mark

    # for each end of month date we insert in an array the corresponding DailyDatum
    # we do this for the fund and the Benchmark

    dates.each do |date|
      fund_data = datas.find_by(calendar: date)
      fund_data_array << fund_data unless fund_data.nil?
      benchmark_data = DataBenchmark.find_by(bench_mark: benchmark, calendar: date)
      benchmark_data_array << benchmark_data unless benchmark_data.nil?
    end
    # then we create the hash to be isnerted in the final array for the graph
    historical_array << { name: fund.best_name, data: fund_data_array.map{|t| [t.calendar.day.strftime("%Y-%m"), t.return_monthly_value.round(2)] } }
    historical_array << { name: benchmark.name, data: benchmark_data_array.map{|t| [t.calendar.day.strftime("%Y-%m"), t.return_monthly_value.round(2)] } }
  end
end
