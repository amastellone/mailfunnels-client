class AddFieldsToEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :is_archived, :integer, :default => 0
  end
end
