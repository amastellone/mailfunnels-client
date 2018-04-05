class AddTemplateFieldsToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :default_template, :text
    add_column :apps, :has_def_template, :integer, :default => 0
  end
end
