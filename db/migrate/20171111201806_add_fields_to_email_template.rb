class AddFieldsToEmailTemplate < ActiveRecord::Migration[5.0]
  def change
    add_column :email_templates, :greet_use_default, :integer, :default => 1
    add_column :email_templates, :greet_before_cust_name, :integer, :default => 0
    add_column :email_templates, :greet_after_cust_name, :integer, :default => 0
    add_column :email_templates, :greet_content, :string
  end
end
