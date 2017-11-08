class HooksController < ApplicationController
  protect_from_forgery with: :null_session

  def process_abandoned_carts
    domain = request.headers['X-Shopify-Shop-Domain']

    if domain.nil? == true
      return
    end

    shop = Shop.find_by(shopify_domain: domain)
    app = App.where(name: domain).first
    ProcessCheckoutsJob.perform_later(app.id, shop)

  end









end
