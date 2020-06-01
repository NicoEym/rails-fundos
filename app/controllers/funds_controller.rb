class FundsController < ApplicationController
  def show
    @fund = Fund.find(params[:id])
    @calendar = Calendar.last
    @aum = Aum.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @share = Share.find_by(calendar_id: @calendar.id, fund_id: @fund.id)
    @date = @calendar.day.to_formatted_s(:long_ordinal)
  end

  def index
    @funds = Fund.where(area_id: params[:area])
  end
end
