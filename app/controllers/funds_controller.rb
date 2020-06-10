class FundsController < ApplicationController
  require "date"

  def show
    #funds is the fund given by the params
    @fund = Fund.find(params[:id])
    #we will get the lastest registered data
    @datas = @fund.daily_data.last
    # we get the date from the last data. Need to improve this. We should get the date before the data.
    @calendar = @datas.calendar

    #we get the explicit date
    @date = @calendar.day

    #now we will work to build the charts
    #We get the history of daily data for the fund we are interested in
    range_data = DailyDatum.where(fund_id: @fund.id)
    #This function will get the history of AUM. The one the history of share price
    @history_aum = get_historical_aum(range_data, 1000000000)
    @history_share = get_historical_share_price(range_data)

    #this function will get the competitors of the fund
    @competitors = get_competitors(@fund)

    #then we use the function to get the returns of the competitors
    @chart_returns = get_returns_data(@competitors, @fund)
    #then we use the function to get the risk/return relation of the competitors and the fund
    @chart_risk_returns = get_risk_returns_data(@competitors, @fund)
  end

  def index
    #if no area params is settled...
    params_area = params[:area_name]
    #... we list all the funds present in the DB
    if params_area.nil?
      @funds = Fund.all
    else
      #... we show only the funds that match the area
      @funds = Fund.where(area_name: params[:area_name])
    end
  end

  def get_historical_aum(datas, divide = 1)
    #for all the daily data, we get the date and the AUM value for the fund.
    #Doing so we have our historical serie of data for the AUM
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.aum / divide]
    end

    historical_array
  end

  def get_historical_share_price(datas)
    #for all the daily data, we get the date and the share price value for the fund.
    #Doing so we have our historical serie of data for the share price
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.share_price]
    end

    historical_array
  end

  def get_competitors(fund)
    #if we do not have a short name, the fund is not from Indosuez, then we display only the indosuez fund as a competitor.
    if fund.short_name.nil?
      competitors = Fund.where(short_name: fund.competitor_group)

    else
    #if we have a shortname, the fund is from Indosuez and then we display all the fund that belongs to this group
      competitors = Fund.where(competitor_group: fund.short_name)
    end

  end


  def get_returns_data(competitors, fund)

    data = []
    #for each competitor we store the name and the value of the monthly return
    competitors.each do |competitor|
      data << [competitor.best_name, competitor.daily_data.last.return_monthly_value]
    end
    #Eventually we do the same for our Indosuez fund
    data << [fund.best_name, fund.daily_data.last.return_monthly_value]
  end

   def get_risk_returns_data(competitors, fund)
    data = []
    #for each competitor we store the name and the couple volatility (x axis) / return (y axis)
    competitors.each do |competitor|
      data << {name: competitor.best_name, data: { competitor.daily_data.last.volatility => competitor.daily_data.last.return_annual_value}}
    end
    #eventually we do the same for the our Indosuez fund
    data << {name: fund.best_name, data: { fund.daily_data.last.volatility => fund.daily_data.last.return_annual_value}}
  end

end
