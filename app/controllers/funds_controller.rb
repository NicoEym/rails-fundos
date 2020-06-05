class FundsController < ApplicationController
  require "date"

  def show
    @fund = Fund.find(params[:id])
    @aum = @fund.aums.last
    @share = @fund.shares.last
    @calendar = @aum.calendar
    @date = @calendar.day
    @name = get_name(@fund)

    range_aum = Aum.where(fund_id: @fund.id)
    @history_aum = get_historical_data(range_aum, 1000000000)

    range_share = Share.where(fund_id: @fund.id)
    @history_share = get_historical_data(range_share)

    @returns = Return.find_by(fund_id: @fund.id, calendar_id: @calendar)
    @applications = Application.find_by(fund_id: @fund.id, calendar_id: @calendar)

    @competitors =get_competitors(@fund)
  end

  def index
    @funds = Fund.where(area_id: params[:area])
  end

  def get_historical_data(datas, divide = 1)
    historical_array = []
    datas.each do |data|
      historical_array << [data.calendar.day, data.value / divide]
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

  def get_name(fund)
    if fund.short_name.nil?
      fund_name = fund.name
    else
      fund_name = fund.short_name
    end
  end
end
