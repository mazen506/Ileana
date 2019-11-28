class ChartsController < AuthenticatedController

  def index
    @charts = Chart.all
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
  end


  def show
    @id = params[:id]
    @chart = Chart.find_by(:id => @id)
    @chart_details = ChartDetail.where(:chart_id => @id)
    @products = ShopifyAPI::Product.find(:all)
    @product_ids = ChartProduct.where(chart_id: @id).select(:product_id).map{|p| p.product_id}
    #@selected_products = ShopifyAPI::Product.find(4290402943029)
    # @selected_products = ShopifyAPI::Product.find(:all, :params => { :id => [4290402943029]})
    @selected_products = @products.select{ |p| @product_ids.include?(p.id.to_s) }
  end

  def destroy
    @id = params[:id]
    Chart.find_by(:id => @id).destroy
    redirect_to '/charts/index',:notice => "Your chart has been deleted !"
  end



  def new
    @products = ShopifyAPI::Product.find(:all)
    @product_ids = Array.new # empty array
    @chart = Chart.new
    @chart.chart_details.new
  end

  def create
    
    @chart = Chart.new(chart_params)
    @shop = Shop.find_by(:shopify_domain => ShopifyAPI::Shop.current.domain)
    @chart_products = Array.new
    @product_ids = params[:chart_product]
    @chart.shop_id = @shop.id
    @chart.description = ""
    ActiveRecord::Base.transaction do
    if @chart.save
      #Add New Product
      @product_ids.each do |product_id|
        @chart_products.push({:chart_id => @chart.id, :product_id => product_id})
      end
      ChartProduct.create(@chart_products)
    
      flash[:success] = "Added Successfully !!"
      redirect_to @chart
    else
            # Reinitialize variables
            @product_ids = Array.new # empty array
            @products = ShopifyAPI::Product.find(:all)
            # Render the new page 
            render action: "new"
    end
   
  end

  end

  def show
    @id = params[:id]
    @chart = Chart.find_by(:id => @id)
    @chart_details = ChartDetail.where(:chart_id => @id)
    
    #Chart Products
    @products = ShopifyAPI::Product.find(:all)
    @product_ids = ChartProduct.where(chart_id: @id).select(:product_id).map{|p| p.product_id}
    @chart_products = @products.select{ |p| @product_ids.include?(p.id.to_s) }
  end

  def add_chart_detail
    @chart.chart_details.new
  end

  def edit
    @id = params[:id]
    @chart = Chart.find_by(:id => @id)
    @chart_details = ChartDetail.where(:chart_id => @id)
    @products = ShopifyAPI::Product.find(:all)
    @product_ids = ChartProduct.where(chart_id: @id).select(:product_id).map{|p| p.product_id}
    #@selected_products = ShopifyAPI::Product.find(4290402943029)
    #@selected_products = ShopifyAPI::Product.find(:all, :params => { :id => [4290402943029]})
    @selected_products = @products.select{ |p| @product_ids.include?(p.id.to_s) }
    # .where(:id=>["4290402943029","4290405204021"])

    if (@id == nil)
      @chart = Chart.new
    end

  end

  def update
    @chart = find_chart
    @chart_products = Array.new
    @product_ids = params[:chart_product]
    @product_ids.each do |product_id|
        @chart_products.push({:chart_id => @chart.id, :product_id => product_id})
    end

    ActiveRecord::Base.transaction do
    #Delete Products
    ChartProduct.where(chart_id: @chart.id).destroy_all

    #Add New Product
    ChartProduct.create(@chart_products)

    if @chart.update(chart_params)
        flash[:success] = "Updated Successfully !!"
        redirect_to chart_path(@chart)
        # respond_to do |format|
        #    format.js {render inline: "location.reload();" }
        #   #redirect_back(fallback_location: root_path)
        #   #
        # end
         
    else
        render 'edit'
    end
    end
  end



  private
  def chart_params
    params.require(:chart).permit(:name, :col_1_caption, :col_2_caption, :col_3_caption, :is_show_product_page, { chart_details_attributes: ChartDetail.attribute_names.map(&:to_sym).push(:_destroy) })
  end

  private
  def chart_details_params
    params.require(:chart_detail).permit(:row_name, :col1, :col2, :col3)
  end

  def find_chart
    @chart = Chart.find(params[:id])
  end



end
