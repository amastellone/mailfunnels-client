class EmailTemplateSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :email_subject, :email_content, :email_title, :has_button, :button_text, :button_url, :color, :app_id, :mf_power_foot, :show_address
  has_one :app
end
