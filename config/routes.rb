MailFunnelServer::Application.routes.draw do

  resources :template_hyperlinks
  resources :broadcast_lists
	mount ResourceApi => '/'

  # Unsubscribe Page Route
  get '/unsubscribe/:subscriber_id', to: 'subscribers#unsubscribe_page'

  # Postmark Webhook Routes
  post '/email_opened' => 'email_jobs#email_opened_hook'

  # Email Clicked Hook Route
  get '/email_clicked/:email_job_id', to: 'email_jobs#email_button_clicked'

  # Admin Statistics
  post '/admin_dashboard_stats', to: 'admin#admin_dashboard_stats'

end