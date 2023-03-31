class UpdateAllAddressLatLng < ActiveRecord::Migration[6.1]
  def change
    addresses = Address.all
    addresses.each do |address|
      Address.getting_latitude_longitude(address)
    end
  end
end
