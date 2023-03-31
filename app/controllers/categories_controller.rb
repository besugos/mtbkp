class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy, :get_category]

  def index
    authorize Category

    @page_name = CategoryType.get_name_by_id(params[:category_type_id])
    
    @categories = CategoriesGrid.new(params[:categories_grid]) do |scope|
      scope.by_category_type_id(params[:category_type_id]).page(params[:page])
    end

    @categories_to_export = CategoriesGrid.new(params[:categories_grid]) do |scope|
      scope.by_category_type_id(params[:category_type_id])
    end

    respond_to do |format|
      format.html
      format.csv do
        send_data @categories_to_export.to_csv(col_sep: ";").encode("ISO-8859-1"), 
        type: "text/csv", 
        disposition: 'inline', 
        filename: Category.model_name.human(count: 2)+" - #{Time.now.to_s}.csv"
      end
    end
  end

  def new
    authorize Category
    @category = Category.new
    @category.category_type_id = params[:category_type_id]
    build_initials_relations
  end

  def edit
    authorize @category
    build_initials_relations
  end

  def create
    authorize Category
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = t('flash.create')
      redirect_to categories_path(category_type_id: @category.category_type_id)
    else
      flash[:error] = @category.errors.full_messages.join('<br>')
      build_initials_relations
      render :new
    end
  end

  def update
    authorize @category
    @category.update(category_params)
    if @category.valid?
      flash[:success] = t('flash.update')
      redirect_to categories_path(category_type_id: @category.category_type_id)
    else
      flash[:error] = @category.errors.full_messages.join('<br>')
      build_initials_relations
      render :edit
    end
  end

  def build_initials_relations
    if @category.sub_categories.select{ |item| item[:id].nil? }.length == 0
      @category.sub_categories.build
    end
    @page_name = CategoryType.get_name_by_id(@category.category_type_id)
  end

  def destroy
    authorize @category
    if @category.destroy
      flash[:success] = t('flash.destroy')
    else
      flash[:error] = @category.errors.full_messages.join('<br>')
    end
    redirect_back(fallback_location: :back)
  end

  def delete_sub_category
    sub_category = SubCategory.where(id: params[:model_id]).first
    if sub_category
      sub_category.destroy
      flash[:success] = t('flash.destroy')
      redirect_to edit_category_path(sub_category.category_id)
    else
      redirect_to categories_path
    end
  end

  def get_category
    data = {
      result: @category
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end
  
  def get_subcategories
    data = {
      result: SubCategory.where(category_id: params[:category_id]).order('name')
    }
    respond_to do |format|
      format.json {render :json => data, :status => 200}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_category
    @category = Category.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white.
  def category_params
    params.require(:category).permit(:id, :name, :category_type_id,
      sub_categories_attributes: [:id, :name, :category_id])
  end
end
