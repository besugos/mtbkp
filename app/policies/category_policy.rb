class CategoryPolicy < ApplicationPolicy

  def general_can_access?
    user.admin?
  end

  def index?
    general_can_access?
  end

  def create?
    general_can_access?
  end

  def new?
    create?
  end

  def update?
    general_can_access?
  end

  def edit?
    update?
  end

  def destroy?
    general_can_access?
  end

end