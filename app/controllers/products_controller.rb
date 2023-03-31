class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :get_product]

  def index
    authorize Product

    if params[:products_grid].nil? || params[:products_grid].blank?
      @products = ProductsGrid.new(:current_user => @current_user)
      @products_to_export = ProductsGrid.new(:current_user => @current_user)
    else
      @products = ProductsGrid.new(params[:products_grid].merge(current_user: @current_user))
      @products_to_export = ProductsGrid.new(params[:products_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @products.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @products.scope {|scope| scope.where(user_id: @current_user.id).page(params[:page]) }
      @products_to_export.scope {|scope| scope.where(user_id: @current_user.id) }
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @products_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Product.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Product
    @product = Product.new
    build_initial_relations
  end

  def edit
    authorize @product
    build_initial_relations
  end

  def create
    authorize Product
    @product = Product.new(product_params)
    if @product.save
      save_images
      DataProfessional.update_active_products(@product.user)
      flash[:success] = t('flash.create')
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.join('<br>')
      build_initial_relations
      render :new
    end
  end

  def update
    authorize @product
    @product.update(product_params)
    if @product.valid?
      save_images
      DataProfessional.update_active_products(@product.user)
      flash[:success] = t('flash.update')
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.join('<br>')
      build_initial_relations
      render :edit
    end
  end

  def save_images
    if !product_params[:images].nil?
      product_params[:images].each do |picture|      
        @product.attachments.create(:attachment => picture)
      end
    end
  end

  def destroy
    authorize @product
    user = @product.user
    if @product.destroy
      DataProfessional.update_active_products(user)
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @product.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def build_initial_relations
    @product.build_address(address_area_id: AddressArea::ENDERECO_SAIDA_ID) if @product.address.nil?
  end

  def get_product
    data = {
      result: @product
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def get_products_values_with_tax
    begin
      data = {
        result: true,
        values: Product.getting_all_values_with_tax(params[:correct_price])
      }
    rescue Exception => e
      data = {
        result: false,
        values: e.message
      }
    end
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_product
    @product = Product.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def product_params
    params.require(:product).permit(:id, 
      :title, :price, :description, :principal_image,
      :category_id, :sub_category_id,
      :user_id,
      :product_condition_id,
      :quantity_stock,
      :promotional_price,
      :width,
      :height,
      :depth,
      :weight,
      :selected_address_id,
      :avaliation_value,
      images: [],
      address_attributes: [:id, :latitude, :longitude, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
      attachments_attributes: [ :id, :attachment ])
  end
end

