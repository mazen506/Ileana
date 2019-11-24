class ChartsController < ApplicationController

  def index
    @charts = Chart.all
  end

  def destroy
    @id = params[:id]
    Chart.find_by(:id => @id).destroy
    redirect_to '/charts/index',:notice => "Your chart has been deleted !"
  end

  def new
    @chart = Chart.new
    @chart.chart_details.new
  end

  def create
    @chart = Chart.new(chart_params)
    @chart.shop_id = 1
    @chart.description = ""
    if @chart.save
      flash[:success] = "Added Successfully !!"
      redirect_to '/charts/index'
    else
      @errors =@chart.errors.full_messages.join(",")
      flash[:error] = "Failed with Error : #{@errors}"
      redirect_to '/charts/new'
    end
  end

  def show
    render :layout => false
  end

  def add_chart_detail
    @chart.chart_details.new
  end

  def edit
    @id = params[:id]
    @chart = Chart.find_by(:id => @id)
    @chart_detail = ChartDetail.new
    @chart_details = ChartDetail.where(:chart_id => @id)
    @chart_products = ChartProduct.where(:chart_id => @id)
    if (@id == nil)
      @chart = Chart.new
    end
  end

  def update
    @chart = find_chart
    if @chart.update(chart_params)
        flash[:success] = "Updated Successfully !!"
        redirect_to '/charts/index'
    else
        render 'index'
    end
  end



  private
  def chart_params
    params.require(:chart).permit(:name, :col_1_caption, :col_2_caption, :col_3_caption, :is_show_product_page, :chart_details_attributes => [:row_name, :col1, :col2, :col3] )
  end

  private
  def chart_details_params
    params.require(:chart_detail).permit(:row_name, :col1, :col2, :col3)
  end

  def find_chart
    @chart = Chart.find(params[:id])
  end



end
