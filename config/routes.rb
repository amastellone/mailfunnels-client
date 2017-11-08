Rails.application.routes.draw do


  # Test Route

  # post '/ajax_test' => 'main_interface#ajax_test'


  # Main
  root :to => 'main_interface#index'

  # Authentication Routes
  get '/login_page' => 'users#login_page'
  post '/ajax_mf_user_auth' => 'users#ajax_mf_user_auth'
  post '/ajax_mf_app_create' => 'users#ajax_mf_app_create'

  # Infusionsoft API Routes
  post '/mf_api_user_create' => 'users#mf_api_user_create'
  post '/mf_api_user_update_tags' => 'users#mf_api_user_update_tags'

  # MailFunnels Webhook Routes
  post '/abandoned_cart_process' => 'hooks#process_abandoned_carts'

  # User Routes
  post '/ajax_change_password' => 'main_interface#ajax_change_password'
  post '/ajax_cancel_subscription' => 'main_interface#ajax_cancel_subscription'
  post '/mf_api_get_user_info' => 'users#mf_api_get_user_info'
  post '/mf_api_manually_add_user' => 'users#mf_api_manually_add_user'

  # Funnel Page Routes
  get '/funnels', to: 'funnels#index'
  get '/edit_funnel/:funnel_id', to: 'funnels#edit_funnel'
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
  post '/ajax_activate_funnel' => 'funnels#ajax_activate_funnel'
  post '/ajax_deactivate_funnel' => 'funnels#ajax_deactivate_funnel'
  post '/ajax_update_funnel_info' => 'funnels#ajax_update_funnel_info'

  # Trigger Routes
  get '/triggers', to: 'triggers#index'
  post '/create_trigger', to: 'triggers#ajax_create_trigger'
  post '/ajax_process_abandoned_carts' => 'triggers#ajax_process_abandoned_carts'
  post '/ajax_load_trigger_info' => 'triggers#ajax_load_trigger_info'
  post '/ajax_load_trigger_funnels' => 'triggers#ajax_load_trigger_funnels'
  post '/ajax_delete_trigger' => 'triggers#ajax_delete_trigger'
  post '/ajax_load_trigger_edit_info' => 'triggers#ajax_load_trigger_edit_info'
  post 'ajax_save_edit_trigger' => 'triggers#ajax_save_edit_trigger'

  # Subscribers Routes
  get '/all_subscribers', to: 'main_interface#all_subscribers'
  get '/all_refund_subscribers', to: 'main_interface#all_refund_subscribers'
  get '/all_abandoned_subscribers', to: 'main_interface#all_abandoned_subscribers'
  get '/list_subscribers/:list_id', to: 'main_interface#list_subscribers'
  post '/ajax_create_subscriber' => 'main_interface#ajax_create_subscriber'
  post '/ajax_load_time_data' => 'main_interface#ajax_load_time_data'
  post '/ajax_create_batch_email' => 'main_interface#ajax_create_batch_email'
  post '/ajax_delete_subscriber' => 'main_interface#ajax_delete_subscriber'
  post '/ajax_load_subscriber_info' => 'main_interface#ajax_load_subscriber_info'
  post '/ajax_remove_from_list' => 'main_interface#ajax_remove_from_list'
  post '/ajax_add_to_list' => 'main_interface#ajax_add_to_list'
  post 'ajax_save_edited_list_info' => 'main_interface#ajax_save_edited_list_info'
  post 'list_subscribers/ajax_delete_email_list' => 'main_interface#ajax_delete_email_list'

  # Email Template Routes
  get '/email_templates', to: 'email#email_templates'
  get '/view_email_template/:template_id', to: 'email#view_email_template'
  get '/edit_email_template/:template_id', to: 'email#edit_email_template'
  get '/view_email', to: 'email#view_email'
  post '/ajax_create_email_template' => 'email#ajax_create_email_template'
  post '/ajax_update_email_template' => 'email#ajax_update_email_template'
  post '/ajax_delete_template' => 'email#ajax_delete_template'

  # Account Routes
  get '/account', to: 'main_interface#account'
  post 'ajax_update_account_info' => 'main_interface#ajax_update_account_info'
  post 'ajax_update_email_info' => 'main_interface#ajax_update_email_info'

  # Email Controller
  get '/lists', to: 'email#lists'
  match '/create_list' => 'email#create_list', via: [:post]
  post '/ajax_create_email_list' => 'email#ajax_create_email_list'

  # Broadcasts Routes
  get '/broadcasts', to: 'broadcast#broadcasts'
  get '/broadcast_info/:id', to: 'broadcast#broadcast_info'
  post '/ajax_new_broadcast' => 'broadcast#ajax_new_broadcast'


  # Admin Routes
  get '/admin_panel', to: 'main_interface#admin_panel'
  post '/ajax_enable_app' => 'main_interface#ajax_enable_app'
  post '/ajax_disable_app' => 'main_interface#ajax_disable_app'
  # Support Routes
  get '/support', to: 'main_interface#support'

  # Subscription Plan Routes
  post '/ajax_upgrade_plan' => 'main_interface#ajax_upgrade_plan'

  # Error Routes
  get '/error_page', to: 'main_interface#error_page'
  get '/account_disabled', to: 'main_interface#account_disabled'
  get '/access_denied', to: 'users#access_denied'
  get '/server_error', to: 'users#server_error'
  get '/trial_access_denied', to: 'main_interface#trial_page_disabled'

  # Import CSV Routes
  post 'import_csv' => 'main_interface#import_csv'



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
