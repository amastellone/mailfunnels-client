class AddFieldsToEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :mf_power_foot, :integer
    add_column :email_templates, :show_address, :integer
  end
end
