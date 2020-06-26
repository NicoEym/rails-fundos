class AreasController < ApplicationController
  # def show
  #   @area = Area.find(params[:id])
  #   @funds = @area.funds
  # end

  def index
    @areas = policy_scope(Area)
  end
end
