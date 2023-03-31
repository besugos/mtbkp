class BannersController < ApplicationController
  before_action :set_banner, only: [:show, :edit, :update, :destroy, :get_banner, :active_banner, :destroy_image_banner]

  def index
    authorize Banner

    if params[:banners_grid].nil? || params[:banners_grid].blank?
      @banners = BannersGrid.new(:current_user => @current_user)
      @banners_to_export = BannersGrid.new(:current_user => @current_user)
    else
      @banners = BannersGrid.new(params[:banners_grid].merge(current_user: @current_user))
      @banners_to_export = BannersGrid.new(params[:banners_grid].merge(current_user: @current_user))
    end

    @banners.scope {|scope| scope.page(params[:page]) }

    respond_to do |format|
      format.html
      format.csv do
        send_data @banners_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Banner.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Banner
    @banner = Banner.new
    build_initial_relations
  end

  def edit
    authorize @banner
    build_initial_relations
  end

  def create
    authorize Banner
    @banner = Banner.new(banner_params)
    if @banner.save
      flash[:success] = t('flash.create')
      redirect_to banners_path
    else
      flash[:error] = @banner.errors.full_messages.join('<br>')
      build_initial_relations
      render :new
    end
  end

  def update
    authorize @banner
    @banner.update(banner_params)
    if @banner.valid?
      flash[:success] = t('flash.update')
      redirect_to edit_banner_path(@banner)
    else
      flash[:error] = @banner.errors.full_messages.join('<br>')
      build_initial_relations
      render :edit
    end
  end

  def destroy
    authorize @banner
    if @banner.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @banner.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def build_initial_relations
  end

  def get_banner
    data = {
      result: @banner
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def active_banner
    authorize @banner
    @banner.update_columns(active: !@banner.active)
    flash[:success] = t('flash.update')
    redirect_back(fallback_location: :back)
  end

  def destroy_image_banner
    authorize @banner
    @banner.image.purge
    @banner.image_mobile.purge
    @banner.update_columns(active: false)
    result = true
    data = {
      result: result
    }
    respond_to do |format|
      format.html do
        flash[:success] = "Imagem removida com sucesso!"
        redirect_back(fallback_location: :back)
      end
      format.json {render :json => data, :status => 200}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_banner
    @banner = Banner.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def banner_params
    params.require(:banner).permit(:id, 
      :image,
      :image_mobile,
      :link,
      :title,
      :position,
      :banner_area_id,
      :active,
      :disponible_date
      )
  end
end
