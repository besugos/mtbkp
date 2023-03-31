class SpecialtiesController < ApplicationController
  before_action :set_specialty, only: [:show, :edit, :update, :destroy, :get_specialty]

  def index
    authorize Specialty

    if params[:specialties_grid].nil? || params[:specialties_grid].blank?
      @specialties = SpecialtiesGrid.new(:current_user => @current_user)
      @specialties_to_export = SpecialtiesGrid.new(:current_user => @current_user)
    else
      @specialties = SpecialtiesGrid.new(params[:specialties_grid].merge(current_user: @current_user))
      @specialties_to_export = SpecialtiesGrid.new(params[:specialties_grid].merge(current_user: @current_user))
    end

    @specialties.scope {|scope| scope.page(params[:page]) }

    respond_to do |format|
      format.html
      format.csv do
        send_data @specialties_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Specialty.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Specialty
    @specialty = Specialty.new
    build_initial_relations
  end

  def edit
    authorize @specialty
    build_initial_relations
  end

  def create
    authorize Specialty
    @specialty = Specialty.new(specialty_params)
    if @specialty.save
      flash[:success] = t('flash.create')
      redirect_to specialties_path
    else
      flash[:error] = @specialty.errors.full_messages.join('<br>')
      build_initial_relations
      render :new
    end
  end

  def update
    authorize @specialty
    @specialty.update(specialty_params)
    if @specialty.valid?
      flash[:success] = t('flash.update')
      redirect_to edit_specialty_path(@specialty)
    else
      flash[:error] = @specialty.errors.full_messages.join('<br>')
      build_initial_relations
      render :edit
    end
  end

  def destroy
    authorize @specialty
    if @specialty.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @specialty.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def build_initial_relations
    # if @specialty.relations.select{ |item| item[:id].nil? }.length == 0
    #  @specialty.relations.build
    # end
    # @specialty.build_relation if @specialty.relation.nil?
  end

  def get_specialty
    data = {
      result: @specialty
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_specialty
    @specialty = Specialty.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def specialty_params
    params.require(:specialty).permit(:id, 
    :name,
    )
  end
end
