class SellerCouponsController < ApplicationController
  before_action :set_seller_coupon, only: [:show, :edit, :update, :destroy, :get_seller_coupon]

  def coupons_to_seller
    authorize SellerCoupon

    if params[:coupons_to_seller_grid].nil? || params[:coupons_to_seller_grid].blank?
      @seller_coupons = CouponsToSellerGrid.new(:current_user => @current_user)
      @seller_coupons_to_export = CouponsToSellerGrid.new(:current_user => @current_user)
    else
      @seller_coupons = CouponsToSellerGrid.new(params[:coupons_to_seller_grid].merge(current_user: @current_user))
      @seller_coupons_to_export = CouponsToSellerGrid.new(params[:coupons_to_seller_grid].merge(current_user: @current_user))
    end

    @seller_coupons.scope {|scope| scope.page(params[:page]) }

    respond_to do |format|
      format.html
      format.csv do
        send_data @seller_coupons_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: SellerCoupon.human_attribute_name(:coupons_to_seller)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def coupons_to_discount
    authorize SellerCoupon

    if params[:coupons_to_discount_grid].nil? || params[:coupons_to_discount_grid].blank?
      @seller_coupons = CouponsToDiscountGrid.new(:current_user => @current_user)
      @seller_coupons_to_export = CouponsToDiscountGrid.new(:current_user => @current_user)
    else
      @seller_coupons = CouponsToDiscountGrid.new(params[:coupons_to_discount_grid].merge(current_user: @current_user))
      @seller_coupons_to_export = CouponsToDiscountGrid.new(params[:coupons_to_discount_grid].merge(current_user: @current_user))
    end

    @seller_coupons.scope {|scope| scope.page(params[:page]) }

    respond_to do |format|
      format.html
      format.csv do
        send_data @seller_coupons_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: SellerCoupon.human_attribute_name(:coupons_to_discount)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize SellerCoupon
    @seller_coupon = SellerCoupon.new(coupon_area_id: params[:coupon_area_id])
    build_initial_relations
  end

  def edit
    authorize @seller_coupon
    build_initial_relations
  end

  def create
    authorize SellerCoupon
    @seller_coupon = SellerCoupon.new(seller_coupon_params)
    if @seller_coupon.save
      flash[:success] = t('flash.create')
      if @seller_coupon.coupon_area_id == CouponArea::CUPOM_DESCONTO_ID
        redirect_to coupons_to_discount_path
      else
        redirect_to coupons_to_seller_path
      end
    else
      flash[:error] = @seller_coupon.errors.full_messages.join('<br>')
      build_initial_relations
      render :new
    end
  end

  def update
    authorize @seller_coupon
    @seller_coupon.update(seller_coupon_params)
    if @seller_coupon.valid?
      flash[:success] = t('flash.update')
      redirect_to edit_seller_coupon_path(@seller_coupon)
    else
      flash[:error] = @seller_coupon.errors.full_messages.join('<br>')
      build_initial_relations
      render :edit
    end
  end

  def destroy
    authorize @seller_coupon
    if @seller_coupon.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @seller_coupon.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def build_initial_relations
    # if @seller_coupon.relations.select{ |item| item[:id].nil? }.length == 0
    #  @seller_coupon.relations.build
    # end
    # @seller_coupon.build_relation if @seller_coupon.relation.nil?
  end

  def get_seller_coupon
    data = {
      result: @seller_coupon
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_seller_coupon
    @seller_coupon = SellerCoupon.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def seller_coupon_params
    params.require(:seller_coupon).permit(:id, 
    :coupon_type_id,
    :coupon_area_id,
    :name,
    :quantity,
    :validate_date,
    :value,
    :quantity_months,
    user_ids: []
    )
  end
end
