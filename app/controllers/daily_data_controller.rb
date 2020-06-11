class DailyDataController < ApplicationController
  def index
    # we display data only for Indosuez funds
    gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
    @funds = Fund.where(gestor: gestor)

    @date = get_last_date
    @datas = get_all_daily_data(@funds, @date)
  end


end
