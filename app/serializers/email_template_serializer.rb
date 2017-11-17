class EmailTemplateSerializer < ActiveModel::Serializer
  attributes :id,
             :name,
             :description,
             :email_subject,
             :email_content,
             :email_title,
             :has_button,
             :button_text,
             :button_url,
             :color,
             :app_id,
             :greet_use_default,
             :greet_before_cust_name,
             :greet_after_cust_name,
             :greet_content

  has_one :app
end
