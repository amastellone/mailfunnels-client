ShopifyApp.configure do |config|

  config.application_name = ENV['APP_NAME']
  # config.api_key = ENV['APP_KEY']
  # config.secret = ENV['APP_SECRET']
  config.api_key = 'b4e2fff6e9e2f1705e83e8984fc169f8'
  config.secret = 'a80a6cd90b4f5c8f08beb2ed15e17f4a'





  # TODO: Verify app_scope works in shipify_app.rb and in .env
  config.scope = "read_orders, read_products, read_checkouts"
  config.embedded_app = true

  config.webhooks = [
    # {topic: 'refunds/create', address: 'https://www.mailfunnels.io/webhooks/refunds_create', format: 'json'},
    # {topic: 'orders/create', address: 'https://www.mailfunnels.io/webhooks/orders_create', format: 'json'},
    # {topic: 'checkouts/create', address: 'https://www.mailfunnels.io/abandoned_cart_process', format: 'json'},
    {topic: 'refunds/create', address: 'https://adefda37.ngrok.io/webhooks/refunds_create', format: 'json'},
    {topic: 'orders/create', address: 'https://adefda37.ngrok.io/webhooks/orders_create', format: 'json'},
    {topic: 'checkouts/create', address: 'https://adefda37.ngrok.io/abandoned_cart_process', format: 'json'},
  ]
end
