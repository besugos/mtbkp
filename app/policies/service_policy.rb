class ServicePolicy < ApplicationPolicy

  def general_can_access?
    user.admin?
  end

  def index?
    user.admin? || user.user?
  end

  def create?
    user.admin? || (user.user? && (!user.data_professional.nil? && !user.data_professional.service_plan.nil? && user.data_professional.quantity_services_left > 0))
  end

  def new?
    create?
  end

  def update?
    user.admin? || (user.user? && record.user_id == user.id)
  end

  def edit?
    update?
  end

  def destroy?
    user.admin? || (user.user? && record.user_id == user.id)
  end

end