class CreateSiteContactSubjects < ActiveRecord::Migration[6.1]
  def change
    create_table :site_contact_subjects do |t|
      t.string :name

      t.timestamps
    end
  end
end
