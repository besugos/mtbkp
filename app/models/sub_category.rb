class SubCategory < ApplicationRecord
  before_destroy :remove_vinculed_data
  belongs_to :category

  has_many :plans
  has_many :products
  has_many :services

  private

  def remove_vinculed_data
    self.plans.update_all(sub_category_id: nil)
    self.products.update_all(sub_category_id: nil)
    self.services.update_all(sub_category_id: nil)
  end
end
