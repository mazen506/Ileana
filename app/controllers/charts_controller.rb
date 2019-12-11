class ChartsController < AuthenticatedController

  def index
    @charts = Chart.all
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
    @chart = Chart.find_by(:id => @id)
    ActiveRecord::Base.transaction do

    #Clear Products Description
    clearProductsDescription

    #Delete Object
    @chart.destroy

    respond_to do |format|
      format.html { redirect_to '/charts/index', :notice => "Your chart has been deleted !" }
      format.json { head :no_content }
      format.js   { flash[:notice] = 'Chart Deleted Successfully..'  }
    end

    end
    # redirect_to '/charts/index',:notice => "Your chart has been deleted !"
  end


  def list_products
      setProducts(params[:id])
      respond_to do |format|
          format.js { render 'list_products.js.erb'}
      end
  end

  def new
    setProducts(nil)
    @chart = Chart.new
    @chart.chart_details.new
  end

  def create

    #Initialize Params
    @new_params = chart_params
    @chart = Chart.new(chart_params)
    @chart_products = Array.new
    @product_ids = params[:chart_product]
    Array(@product_ids).each do |product_id|
      @chart_product = ChartProduct.new
      @chart_product.product_id = product_id
      @chart.chart_products.push(@chart_product)
    end
    @shop = Shop.find_by(:shopify_domain => ShopifyAPI::Shop.current.domain)
    @chart.shop_id = @shop.id
    
    #Validate Object
    if(!@chart.valid?)
      # Reinitialize Product list Before rendering 
      setProducts(nil)
      render 'new'
      return
    end

    @chart.description = ""

    ActiveRecord::Base.transaction do
    
    #Construct Table
    constructTable

    #Update Product Descriptions
    updateProductsDescription

    if @chart.save
      # @product_ids.each do |product_id|
      #   @chart_products.push({:chart_id => @chart.id, :product_id => product_id})
      # end
      # ChartProduct.create(@chart_products)
      flash[:success] = "Added Successfully !!"
      redirect_to "/charts/index"
    else
            # Reinitialize variables
            setProducts(nil)
            # Render the new page 
            render "new"
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

  def setProducts(chart_id)
    @products = ShopifyAPI::Product.find(:all)
    @product_ids = Array.new
    @selected_products = Array.new
    if (!chart_id.nil?)
        #Get Product Ids
        @product_ids = ChartProduct.where(chart_id: chart_id).select(:product_id).map{|p| p.product_id}
        
        #Selected Products
        @selected_products = @products.select{ |p| @product_ids.include?(p.id.to_s) }
            #Exclude already added products for other charts
        @assigned_product_ids = ChartProduct.where.not(chart_id: chart_id).select(:product_id).map{|p| p.product_id}
        @products = @products.select{ |p| not @assigned_product_ids.include?(p.id.to_s) }
    else
    
        @assigned_product_ids = ChartProduct.select(:product_id).map{|p| p.product_id}
        @products = @products.select{ |p| not @assigned_product_ids.include?(p.id.to_s) }
    end

  end

  def edit
    @id = params[:id]
    @chart = Chart.find_by(:id => @id)
    @chart_details = ChartDetail.where(:chart_id => @id)

    setProducts(@id)
    if (@id == nil)
      @chart = Chart.new
    end

  end

  def constructTable
       # Construct Table Structure
   @table_structure = "<!-- StartIleanaApp -->"\
   "<script type='text/javascript' src='mydomain.com/widget.js'>\n"\
   "<div style='text-align: center;'' class='ilea-chart'>#{chart_params['name']}</div>\n"\
   "<table style='​display: none;​' width='613' border='0' cellpadding='0' id='ChartNameByUser' class='ileana-chart'>\n"\
   "<thead>\n"\
     "<th>Row Name</th>\n"\
     "<th>#{chart_params['col_1_caption']}</th>\n"\
     "<th>#{chart_params['col_2_caption']}</th>\n"\
     "<th>#{chart_params['col_3_caption']}</th>\n"\
   "</thead>\n"\
   "<tbody>\n"
@chart_details = chart_params['chart_details_attributes']
@chart_details.each do |chart_detail|
@table_structure = @table_structure + "<tr>\n"\
      "<td>#{chart_detail[1]['row_name']}</td>\n"\
      "<td>#{chart_detail[1]['col1']}</td>\n"\
      "<td>#{chart_detail[1]['col2']}</td>\n"\
      "<td>#{chart_detail[1]['col3']}</td>\n"\
      "</tr>\n"
end
@table_structure = @table_structure + "</tbody>\n"
end

def updateProductsDescription
      #Update Description for selected products
      if (!(@product_ids.nil? || @product_ids.empty?))
        @product_ids.each do |product_id|
          @product = ShopifyAPI::Product.find(product_id) 
          if (@product != nil)
              @body_html = @product.body_html
              @script_pos = @body_html.index('<!-- StartIleanaApp -->')
              if (!@script_pos.nil?)
                  @body_html = @body_html.slice(0..(@script_pos-1)) 
              end
                @product.body_html = @body_html + @table_structure
                @product.save
           end
        end
      end
end

def clearProductsDescription
     #Get Removed Products & Remove Product Description
     @old_product_ids = ChartProduct.where(chart_id: @chart.id).select(:product_id).map{|p| p.product_id}
     if (!(@old_product_ids.nil? || @old_product_ids.empty?))
       if (@product_ids.nil?) #Delete
          @removed_product_ids = @old_product_ids
       else
          @removed_product_ids = @old_product_ids - @product_ids
       end

       if (!(@removed_product_ids.nil? || @removed_product_ids.empty?))
          @removed_product_ids.each do |product_id|
            @product = ShopifyAPI::Product.find(product_id) 
            if (@product != nil)
                @body_html = @product.body_html
                @script_pos = @body_html.index('<!-- StartIleanaApp -->')
                if (!@script_pos.nil?)
                  @body_html = @body_html.slice(0..(@script_pos-1)) 
                  @product.body_html = @body_html
                  @product.save
                end
             end
          end
        end
      end
end


def update

    #Initialize
    @chart = find_chart
    @chart.assign_attributes( chart_params)
    @chart_products = Array.new
    @product_ids = params[:chart_product]
    @chart.chart_products.destroy_all
    Array(@product_ids).each do |product_id|
        @chart_product = ChartProduct.new
        @chart_product.product_id = product_id
        @chart.chart_products.push(@chart_product)
    end


    if(!@chart.valid?)
        setProducts(@chart.id)
        render 'edit'
        return
    end


    ActiveRecord::Base.transaction do
      #Begin Transaction
      # Update Products Descriptions
      # Update ChartsProducts Table
      # Update Chart Table


   #Construct Table to be inserted into product descriptions
   constructTable

  
    #clearRemovedProductsDescription
    clearProductsDescription

  
    #Update product descriptions
    updateProductsDescription

    #Update ChartProducts Table
    # ChartProduct.where(chart_id: @chart.id).destroy_all
    # ChartProduct.create(@chart_products)

     if @chart.update(chart_params)
        flash[:success] = "Updated Successfully!!"
        render "update"
     else
        setProducts(@chart.id)
        render "edit"
     end

   end # End Transation 
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
