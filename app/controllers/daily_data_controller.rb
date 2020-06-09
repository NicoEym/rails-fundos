class DailyDataController < ApplicationController


  def index
    gestor = Gestor.find_by(name: "Ca Indosuez Wealth (Brazil) S.A. Dtvm")
    @funds = Fund.where(gestor: gestor)
    @date = Calendar.last.day
  end

end
