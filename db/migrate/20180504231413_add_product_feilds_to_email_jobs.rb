class AddProductFeildsToEmailJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :email_jobs, :product_title, :string
    add_column :email_jobs, :product_description, :text
    add_column :email_jobs, :product_image, :string
    add_column :email_jobs, :product_price, :string
  end
end
