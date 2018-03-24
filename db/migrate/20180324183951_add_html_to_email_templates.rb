class AddHtmlToEmailTemplates < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :html, :text
    add_column :email_templates, :style_type, :integer, :default => 0
  end
end
