class AddLatLngToAddresses < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :latitude, :string
    add_column :addresses, :longitude, :string
  end
end