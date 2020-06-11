class DailyDataController < ApplicationController


  def index
    #we display data only for Indosuez funds
    gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
    @funds = Fund.where(gestor: gestor)

    @date = DailyDatum.last_common_day.day
  end


  # def get_last_date
  #   last_dates = Calendar.last(5).reverse
  #   last_dates.each do |last_date|
  #     number_of_fund_for_date = DailyDatum.where(calendar_id: last_date.id).count
  #     puts number_of_fund_for_date
  #     number_of_funds = Fund.count
  #     puts number_of_funds
  #     return date = last_date if number_of_fund_for_date == 17
  #   end

  # end
end
