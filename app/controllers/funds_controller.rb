class FundsController < ApplicationController
  require "date"

  def show
    @fund = Fund.find(params[:id])
    @aum = @fund.aum.last
    @share = @fund.share.last
    @calendar = @aum.calendar
    @date = @calendar.day

    range_aum = Aum.where(fund_id: @fund.id)
    @history_aum = get_historical_data(range_aum, 1000000000)

    range_share = Share.where(fund_id: @fund.id)
    @history_share = get_historical_data(range_share)

    @returns = Return.find_by(fund_id: @fund.id, calendar_id: @calendar)
    @applications = Application.find_by(fund_id: @fund.id, calendar_id: @calendar)

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

end
