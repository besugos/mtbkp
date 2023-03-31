class SystemConfigurationPolicy < ApplicationPolicy
  
  def update?
    user.admin?
  end

  def edit?
    update?
  end

end
