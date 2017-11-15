class AddDefaultColorToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :email_def_color, :string, :default => '#3b99d8'
  end
end
