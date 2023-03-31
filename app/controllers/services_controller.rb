class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy, :get_service]

  def index
    authorize Service

    if params[:services_grid].nil? || params[:services_grid].blank?
      @services = ServicesGrid.new(:current_user => @current_user)
      @services_to_export = ServicesGrid.new(:current_user => @current_user)
    else
      @services = ServicesGrid.new(params[:services_grid].merge(current_user: @current_user))
      @services_to_export = ServicesGrid.new(params[:services_grid].merge(current_user: @current_user))
    end

    if @current_user.admin?
      @services.scope {|scope| scope.page(params[:page]) }
    elsif @current_user.user?
      @services.scope {|scope| scope.where(user_id: @current_user.id).page(params[:page]) }
      @services_to_export.scope {|scope| scope.where(user_id: @current_user.id) }
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @services_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Service.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Service
    @service = Service.new
    build_initial_relations
  end

  def edit
    authorize @service
    build_initial_relations
  end

  def create
    authorize Service
    @service = Service.new(service_params)
    if @service.save
      save_images
      DataProfessional.update_active_services(@service.user)
      Service.validating_lat_lng_address(@service)
      flash[:success] = t('flash.create')
      redirect_to services_path
    else
      flash[:error] = @service.errors.full_messages.join('<br>')
      build_initial_relations
      render :new
    end
  end

  def update
    authorize @service
    @service.update(service_params)
    if @service.valid?
      save_images
      DataProfessional.update_active_services(@service.user)
      Service.validating_lat_lng_address(@service)
      flash[:success] = t('flash.update')
      redirect_to services_path
    else
      flash[:error] = @service.errors.full_messages.join('<br>')
      build_initial_relations
      render :edit
    end
  end

  def destroy
    authorize @service
    user = @service.user
    if @service.destroy
      DataProfessional.update_active_services(user)
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @service.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def build_initial_relations
    # if @service.relations.select{ |item| item[:id].nil? }.length == 0
    #  @service.relations.build
    # end
    # @service.build_relation if @service.relation.nil?
    @service.build_address(address_area_id: AddressArea::ENDERECO_SAIDA_ID) if @service.address.nil?
  end

  def get_service
    data = {
      result: @service
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def save_images
    if !service_params[:images].nil?
      service_params[:images].each do |picture|      
        @service.attachments.create(:attachment => picture)
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_service
    @service = Service.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def service_params
    params.require(:service).permit(:id, 
      :category_id,
      :sub_category_id,
      :user_id,
      :radius_service_id,
      :name,
      :price,
      :tags,
      :active,
      :description,
      :principal_image,
      :selected_address_id,
      :avaliation_value,
      :activate_budget,
      :budget_whatsapp,
      images: [],
      service_goal_ids: [],
      service_ground_ids: [],
      service_ground_type_ids: [],
      address_attributes: [:id, :latitude, :longitude, :ownertable_type, :ownertable_id, :page_title, :address_type_id, :address_area_id, :name, :zipcode, :address, :district, :number, :complement, :address_type, :state_id, :city_id, :country_id, :reference],
      attachments_attributes: [:id, :attachment]
      )
  end
end
