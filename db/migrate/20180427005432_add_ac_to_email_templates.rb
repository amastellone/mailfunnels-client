class AddAcToEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :has_ac_holder, :integer, :default => 0
  end
end
