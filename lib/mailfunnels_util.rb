class MailfunnelsUtil < ShopifyApp::AuthenticatedController

  def self.get_app_name
      domain = ShopifyAPI::Shop.current.myshopify_domain
    return domain
  end

  def self.get_app_id
    return App.where(name: MailfunnelsUtil.get_app_name).first.id
  end

  def self.get_app
    return App.where(name: MailfunnelsUtil.get_app_name).first
  end

end