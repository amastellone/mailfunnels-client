class AddFooterFieldsToApp < ActiveRecord::Migration[5.0]

  def up
    change_column :apps, :show_mf_powered, :integer, :default => 1
  end

  def change
    add_column :apps, :foot_use_bill_add, :integer, :default => 1
    add_column :apps, :foot_street, :string
    add_column :apps, :foot_city, :string
    add_column :apps, :foot_state, :string
    add_column :apps, :foot_zip, :string
  end
end
