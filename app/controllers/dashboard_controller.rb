class DashboardController < ApplicationController
  def index
    @charts = Chart.all
  end

  def destroy
    @id = params[:id]
    Chart.find_by(:id => @id).destroy
    redirect_to '/charts/index',:notice => "Your chart has been deleted !"
  end
end
