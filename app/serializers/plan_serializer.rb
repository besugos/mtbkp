class PlanSerializer < ActiveModel::Serializer
  
  attributes :id, 
  :name,
  :price,
  :old_price,
  :active,
  :category_id, 
  :sub_category_id,
  :category, 
  :sub_category,
  :description,
  :observations

  attribute :price_formatted do
    CustomHelper.to_currency(object.price)
  end
  
  attribute :old_price_formatted do
    CustomHelper.to_currency(object.old_price)
  end
  
  attribute :image_url do
    CustomHelper.url_for(object.image)
  end
  
  attribute :banner_image_url do
    CustomHelper.url_for(object.banner_image)
  end

  has_many :plan_services

end
