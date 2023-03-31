class PlansController < ApplicationController
  before_action :set_plan, only: [:show, :edit, :update, :destroy, :get_plan, :block]

  def index
    authorize Plan

    @page_name = PlanType.get_name_by_id(params[:plan_type_id])

    if params[:plans_grid].nil? || params[:plans_grid].blank?
      @plans = PlansGrid.new(current_user: @current_user, plan_type_id: params[:plan_type_id])
      @plans_to_export = PlansGrid.new(current_user: @current_user, plan_type_id: params[:plan_type_id])
    else
      @plans = PlansGrid.new(params[:plans_grid].merge(current_user: @current_user, plan_type_id: params[:plan_type_id]))
      @plans_to_export = PlansGrid.new(params[:plans_grid].merge(current_user: @current_user, plan_type_id: params[:plan_type_id]))
    end
    
    @plans.scope {|scope| scope.by_plan_type_id(params[:plan_type_id]).page(params[:page])}
    @plans_to_export.scope {|scope| scope.by_plan_type_id(params[:plan_type_id])}

    respond_to do |format|
      format.html
      format.csv do
        send_data @plans_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Plan.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Plan
    @plan = Plan.new
    @plan.plan_type_id = params[:plan_type_id]
    build_initials_relations
  end

  def edit
    authorize @plan
    build_initials_relations
  end

  def create
    authorize Plan
    @plan = Plan.new(plan_params)
    if @plan.save
      flash[:success] = t('flash.create')
      redirect_to plans_path(plan_type_id: @plan.plan_type_id)
    else
      flash[:error] = @plan.errors.full_messages.join('<br>')
      build_initials_relations
      render :new
    end
  end

  def update
    authorize @plan
    @plan.update(plan_params)
    if @plan.valid?
      flash[:success] = t('flash.update')
      redirect_to plans_path(plan_type_id: @plan.plan_type_id)
    else
      flash[:error] = @plan.errors.full_messages.join('<br>')
      build_initials_relations
      render :edit
    end
  end

  def build_initials_relations
    @page_name = PlanType.get_name_by_id(@plan.plan_type_id)
  end

  def destroy
    authorize @plan
    if @plan.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @plan.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def get_plan
    data = {
      result: @plan
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  def block
    authorize @plan
    if !@plan.active
      text = Plan.human_attribute_name(:reactived)
    else
      text = Plan.human_attribute_name(:inactive)
    end
    if @plan.update_column(:active, !@plan.active)
      flash[:success] = text+I18n.t('model.with_sucess')
    else
      flash[:error] = @plan.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_plan
    @plan = Plan.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def plan_params
    params.require(:plan).permit(:id, 
      :name,
      :price,
      :old_price,
      :active,
      :image,
      :banner_image,
      :category_id, :sub_category_id,
      :plan_periodicity_id,
      :description,
      :observations,
      :plan_type_id,
      :limit_products,
      :limit_service_categories,
      plan_services_attributes: [:id, :plan_id, :title, :show]
      )
  end
end
