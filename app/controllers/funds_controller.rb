class FundsController < ApplicationController
  def show
    @fund = Fund.find(params[:id])
    @calendar = Calendar.last
    @aum = Aum.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @share = Share.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @date = @calendar.day.to_formatted_s(:long_ordinal)


    range_aum = Aum.where(fund_id: @fund.id)
    @history_aum = get_historical_data(range_aum, 1000000000)

    range_share = Share.where(fund_id: @fund.id)
    @history_share = get_historical_data(range_share)
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
