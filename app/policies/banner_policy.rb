class BannerPolicy < ApplicationPolicy

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

  def active_banner?
    general_can_access? && (record.image.attached? || record.image_mobile.attached?)
  end

  def destroy_image_banner?
    destroy? && (record.image.attached? || record.image_mobile.attached?)
  end

end