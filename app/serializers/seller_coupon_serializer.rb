class SellerCouponSerializer < ActiveModel::Serializer
  attributes :id, :name, :quantity, :validate, :value
  has_one :coupon_type
end
