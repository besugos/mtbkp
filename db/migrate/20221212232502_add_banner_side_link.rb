class AddBannerSideLink < ActiveRecord::Migration[6.1]
  def change
    add_column :system_configurations, :size_banner_link, :string
  end
end
