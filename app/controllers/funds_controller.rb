class FundsController < ApplicationController
  def show
    @fund = Fund.find(params[:id])
    @calendar = Calendar.last
    @aum = Aum.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @share = Share.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @date = @calendar.day.to_formatted_s(:long_ordinal)


    range_aum = Aum.where(fund_id: @fund.id)
    @history_aum = history(@fund, range_aum)


    range_share = Share.where(fund_id: @fund.id)
    @history_share = history(@fund, range_share)
  end

  def index
    @funds = Fund.where(area_id: params[:area])
  end

  def history(fund, datas)
    history = []
    datas.each do |data|
      history << [data.calendar.day, data.value]
    end

    history
  end

end
