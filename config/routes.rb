Rails.application.routes.draw do
  # Main
  root :to => 'main_interface#index'

  # MailFunnels Install Route
  get '/mailfunnels_install' => 'application#mailfunnels_install'
  get '/mailfunnels_auth' => 'application#mailfunnels_auth'

  # MailFunnels Webhook Routes
  post '/order_create_webhook' => 'application#order_create_webhook'

  # Funnel Page Routes
  get '/funnels', to: 'funnels#index'
  get '/edit_funnel/:funnel_id', to: 'funnels#edit_funnel'
  get '/new_email_template', to: 'funnels#new_email_template'
  post '/ajax_delete_funnel' => 'funnels#ajax_delete_funnel'

  # Funnel Editor POST Routes
  post '/create_funnel' => 'funnels#ajax_create_funnel'
  post '/ajax_add_new_node' => 'funnels#ajax_add_node'
  post '/ajax_load_funnel_json' => 'funnels#ajax_load_funnel_json'
  post '/ajax_save_node' => 'funnels#ajax_save_node'
  post '/ajax_add_link' => 'funnels#ajax_add_link'
  post '/ajax_load_node_info' => 'funnels#ajax_load_node_info'
  post '/ajax_load_email_template_info' => 'funnels#ajax_load_email_template_info'
  post '/ajax_delete_node' => 'funnels#ajax_delete_node'
  post '/ajax_load_node_edit_info' => 'funnels#ajax_load_node_edit_info'
  post '/ajax_save_edit_node' => 'funnels#ajax_save_edit_node'

  # Trigger Routes
  get '/triggers', to: 'triggers#index'
  post '/create_trigger', to: 'triggers#ajax_create_trigger'
  post '/ajax_process_abandoned_carts' => 'triggers#ajax_process_abandoned_carts'

  # Subscribers Routes
  get '/all_subscribers', to: 'main_interface#all_subscribers'
  get '/list_subscribers/:list_id', to: 'main_interface#list_subscribers'
  post '/ajax_create_subscriber' => 'main_interface#ajax_create_subscriber'
  post '/ajax_load_time_data' => 'main_interface#ajax_load_time_data'
  post '/ajax_create_batch_email' => 'main_interface#ajax_create_batch_email'
  post '/ajax_delete_subscriber' => 'main_interface#ajax_delete_subscriber'
  post '/ajax_load_subscriber_info' => 'main_interface#ajax_load_subscriber_info'

  # Email Template Routes
  get '/email_templates', to: 'email#email_templates'
  get '/view_email_template/:template_id', to: 'email#view_email_template'
  get '/edit_email_template/:template_id', to: 'email#edit_email_template'
  get '/view_email', to: 'email#view_email'
  post '/ajax_create_email_template' => 'email#ajax_create_email_template'
  post '/ajax_update_email_template' => 'email#ajax_update_email_template'

  # Account Routes
  get '/account', to: 'main_interface#account'
  post 'ajax_update_account_info' => 'main_interface#ajax_update_account_info'


  # Email Controller
  get '/lists', to: 'email#lists'
  match '/create_list' => 'email#create_list', via: [:post]
  post '/ajax_create_email_list' => 'email#ajax_create_email_list'


  # Admin Routes
  get '/admin_panel', to: 'main_interface#admin_panel'
  post '/ajax_enable_app' => 'main_interface#ajax_enable_app'
  post '/ajax_disable_app' => 'main_interface#ajax_disable_app'


  # Error Routes
  get '/error_page', to: 'main_interface#error_page'
  get '/account_disabled', to: 'main_interface#account_disabled'



  # Shopify Routes
  get 'modal' => "home#modal", :as => :modal
  get 'modal_buttons' => "home#modal_buttons", :as => :modal_buttons
  get 'regular_app_page' => "home#regular_app_page"
  get 'help' => "home#help"
  get 'pagination' => "home#pagination"
  get 'breadcrumbs' => "home#breadcrumbs"
  get 'buttons' => "home#buttons"
  get 'form_page' => "home#form_page"
  post 'form_page' => "home#form_page"
  get 'error' => 'home#error'

  mount ShopifyApp::Engine, at: '/'

end
