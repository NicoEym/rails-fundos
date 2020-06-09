class FundsController < ApplicationController
  require "date"

  def show
    @fund = Fund.find(params[:id])
    @datas = @fund.daily_data.last

    @calendar = @datas.calendar
    @date = @calendar.day


    range_data = DailyDatum.where(fund_id: @fund.id)
    @history_aum = get_historical_aum(range_data, 1000000000)
    @history_share = get_historical_share_price(range_data)

    @today_datas = DailyDatum.find_by(fund_id: @fund.id, calendar_id: @calendar)

    @competitors = get_competitors(@fund)
    @chart_returns = get_returns_data(@competitors, @fund)
    @chart_risk_returns = get_risk_returns_data(@competitors, @fund)
  end

  def index
    params_area = params[:area]

    if params_area.nil?
      @funds = Fund.all
    else
      @funds = Fund.where(area_id: params[:area])
    end
  end

  def get_historical_aum(datas, divide = 1)
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.aum / divide]
    end

    historical_array
  end

  def get_historical_share_price(datas)
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

    competitors.each do |competitor|
      data << [competitor.name, competitor.daily_data.last.return_monthly_value]
    end
    data << [fund.name, fund.daily_data.last.return_monthly_value]
  end

   def get_risk_returns_data(competitors, fund)
    data = []

    competitors.each do |competitor|
      data << {name: competitor.best_name, data: { competitor.daily_data.last.volatility => competitor.daily_data.last.return_annual_value}}
    end
    data << {name: fund.best_name, data: { fund.daily_data.last.volatility => fund.daily_data.last.return_annual_value}}
  end

end
