class AddFieldsToApp < ActiveRecord::Migration[5.0]
  def change
    add_column :apps, :show_mf_powered, :integer
  end
end
