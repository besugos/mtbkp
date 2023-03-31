class CreateSystemConfigurations < ActiveRecord::Migration[6.1]
  def change
    create_table :system_configurations do |t|
      t.string :notification_mail
      t.string :contact_mail
      t.text :use_policy, :limit => 4294967295
      t.text :exchange_policy, :limit => 4294967295
      t.text :warranty_policy, :limit => 4294967295
      t.text :privacy_policy, :limit => 4294967295
      t.string :phone
      t.string :cellphone
      t.string :cnpj
      t.text :data_security_policy, :limit => 4294967295
      t.text :quality, :limit => 4294967295
      t.text :about, :limit => 4294967295
      t.text :mission, :limit => 4294967295
      t.text :view, :limit => 4294967295
      t.text :values, :limit => 4294967295
      t.string :linkedin_link
      t.string :site_link
      t.string :facebook_link
      t.string :instagram_link
      t.string :twitter_link
      t.string :youtube_link
      t.string :id_google_analytics
      t.string :page_title
      t.string :page_description

      t.text :geral_conditions, :limit => 4294967295
      t.text :contract_data, :limit => 4294967295

      t.text :attendance_data, :limit => 4294967295

      t.string :about_video_link

      t.decimal :percent_order_products, :precision => 15, :scale => 2, default: 0
      t.integer :maximum_installments, default: 1
      t.integer :maximum_installment_plans, default: 1

      t.string :plan_name
      t.string :plan_price, :precision => 15, :scale => 2
      t.string :plan_description

      t.string :professional_contact_phone
      t.string :client_contact_phone
      t.string :professional_contact_mail
      t.string :client_contact_mail

      t.timestamps
    end
  end
end