class UserPolicy < ApplicationPolicy
  
  def users_admin?
    user.admin?
  end
  
  def users_user?
    user.admin?
  end

  def create?
    user.admin?
  end

  def new?
    create?
  end

  def update?
    !user.nil? && user.admin? || user.id == record.id
  end

  def edit?
    update?
  end

  def generate_contract?
    user.admin?
  end

  def change_access_data?
    update? && (record.provider.nil? || record.provider.blank?)
  end

  def update_access_data?
    update?
  end

  def block?
    !user.nil? && user.admin? && user.id != record.id && record.id != 2
  end

  def destroy?
    !user.nil? && user.admin? && user.id != record.id && record.id != 2
  end

  def open_chat?(receiver)
    return (receiver.id.to_i != user.id) || user.admin?
  end

  def destroy_profile_image?
    user.admin? || (user.user? && record.id == user.id)
  end

  def send_push_test?
    user.id == 1
  end

  def send_push_to_mobile?
    send_push_test?
  end

  def user_addresses?
    user.admin? || user.user?
  end

  def view_my_addresses?
    user.user?
  end

  def view_my_cards?
    user.user?
  end

  def new_user_address?
    create_user_address?
  end
  
  def create_user_address?
    user.admin? || user.user?
  end
  
  def update_user_address?(address)
    user.admin? || (user.user? && address.ownertable_type == "User" && address.ownertable_id == user.id)
  end
  
  def edit_user_address?(address)
    update_user_address?(address)
  end
  
  def destroy_user_address?(address)
    update_user_address?(address)
  end

  def user_cards?
    user.admin? || user.user?
  end
  
  def create_user_card?
    user.admin? || user.user?
  end
  
  def update_user_card?
    user.admin? || (user.user? && record.ownertable_type == "User" && record.ownertable_id == user.id)
  end
  
  def destroy_user_card?
    update_user_card?
  end
  
  def can_approve_documents?
    user.admin?
  end
  
  def can_view_approve_documents?
    user.user? || Rails.env.development?
  end
  
  def change_seller_verified?
    !user.nil? && user.admin?
  end

  def chats?
    !user.nil?
  end
  
end
