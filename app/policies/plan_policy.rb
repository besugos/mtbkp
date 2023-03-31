class PlanPolicy < ApplicationPolicy

  def general_can_access?
    user.admin?
  end

  def index?
    general_can_access?
  end

  def create?
    false
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
    false
  end

  def block?
    user.admin?
  end

end