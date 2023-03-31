class ChangeFacebookColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column(:system_configurations, :facebook_link, :text)
    change_column(:system_configurations, :linkedin_link, :text)
    change_column(:system_configurations, :instagram_link, :text)
    change_column(:system_configurations, :twitter_link, :text)
    change_column(:system_configurations, :youtube_link, :text)
  end
end
