class CreateTemplateHyperlinks < ActiveRecord::Migration[5.0]
  def change
    create_table :template_hyperlinks do |t|

      t.references :app, foreign_key: {on_delete: :cascade}
      t.references :email_template, foreign_key: {on_delete: :cascade}
      t.string :site_url

      t.timestamps
    end
  end
end
