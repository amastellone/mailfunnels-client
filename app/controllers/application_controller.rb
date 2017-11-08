class ApplicationController < ActionController::Base
  before_action :verify_mf_integrity


  def verify_mf_integrity
    puts "======================="
    puts "application_controller :: verify_mf_integrity"
    begin
      # Retrieve the shopify domain from the params
      domain = params[:shop]

      # check if the domain is null
      if domain.nil?
        puts "INFO - shop domain is not specified"
        puts "---- Returning (SUCCESS) ----"
        puts "======================="
        return
      end

      # retrieve app using domain name
      app = App.where(name: domain).first

      # check if app was retrieved successfully
      if app.nil?
        puts "ERROR - app not found with name = #{domain}"
        puts "---- Redirecting to /access_denied (FAILURE) ----"
        puts "======================="
        redirect_to '/access_denied' and return
      end

      # retrieve user from db
      user = User.where(id: app.user_id).first

      # check if user was retrieved successfully
      if user.nil?
        puts "ERROR - user not found with id = #{app.user_id}"
        puts "---- Redirecting to /access_denied (FAILURE) ----"
        puts "======================="
        redirect_to '/access_denied' and return
      end

      #check if user is trial user
      checker = MailFunnelsUser.is_trial_user(user.clientid)

      #check for error and if trial is valid
      if checker != 0 && checker != -1
        case checker
          when 1
            if MailFunnelsUser.is_regular_trial_valid(user.clientid)
              puts "INFO - User with id = #{user.id} has a regular trial that is VALID"
              puts "---- Returning (SUCCESS) ----"
              puts "======================="
              return
            else
              puts "INFO - User with id = #{user.id} has a regular trial that is INVALID"
              puts "---- Redirecting to /access_denied (SUCCESS) ----"
              puts "======================="
              redirect_to '/access_denied' and return
            end
          when 2
            if MailFunnelsUser.is_student_trial_valid(user.clientid)
              puts "INFO - User with id = #{user.id} has a student trial that is VALID"
              puts "---- Returning (SUCCESS) ----"
              puts "======================="
              return
            else
              puts "INFO - User with id = #{user.id} has a student trial that is INVALID"
              puts "---- Redirecting to /access_denied (SUCCESS) ----"
              puts "======================="
              redirect_to '/access_denied' and return
            end
          else
            puts "Shouldn't ever get here"
            puts "---- Redirecting to /server_error (FAILURE) ----"
            puts "======================="
            redirect_to '/server_error' and return
        end
      end

      # Retrieve the user's current plan
      userplan = MailFunnelsUser.get_user_plan(user.clientid)

      # check if user plan is valid
      if userplan <= 1
        case userplan
          when 1
            puts "WARN - User with id = #{user.id} has NO subscription"
            puts "---- Redirecting to /access_denied (SUCCESS) ----"
            puts "======================="
            redirect_to '/access_denied' and return
          when -1
            puts "ERROR - User with id = #{user.id} has caused an error while trying to retrieve plan"
            puts "---- Redirecting to /access_denied (FAILURE) ----"
            puts "======================="
            redirect_to '/access_denied' and return
          else
            puts "Shouldn't ever get here"
            puts "---- Redirecting to /server_error (FAILURE) ----"
            puts "======================="
            redirect_to '/server_error' and return
        end
      end

      # check if user has failed to pay an installment
      has_failed_payment = MailFunnelsUser.has_failed_payment(user.clientid)

      # check for error
      if has_failed_payment == -1
        puts "ERROR - User with id = #{user.id} has caused an error while trying to retrieve failed payment status"
        puts "---- Redirecting to /access_denied (FAILURE) ----"
        puts "======================="
        redirect_to '/access_denied' and return
      end

      # check for failed payment
      if has_failed_payment
        puts "WARN - User with id = #{user.id} has failed to pay for an installment"
        puts "---- Redirecting to /access_denied (SUCCESS) ----"
        puts "======================="
        redirect_to '/access_denied' and return
      end

      # If App does not have auth_token set, update the auth token
      unless app.auth_token
        digest = OpenSSL::Digest.new('sha256')
        token = Base64.encode64(OpenSSL::HMAC.digest(digest, ENV['SECRET_KEY_BASE'], domain)).strip
        app.put('', {
            :auth_token => token
        })
      end
      puts "INFO - User with id = #{user.id} has passed all requirements"
      puts "---- Returning (SUCCESS) ----"
      puts "======================="
    end
  end


  helper_method :current_shop, :shopify_session

  private

  def current_shop

    @current_shop ||= Shop.find(session[:shop_id]) if session[:shop_id].present?
  end

  def shopify_session
    unless current_shop.nil?

      api_key = Rails.configuration.shopify_api_key
      token = current_shop.token
      domain = current_shop.domain

      ShopifyAPI::Base.site = "https://#{api_key}:#{token}@#{domain}/admin"
    end

    yield

  ensure
    ShopifyAPI::Base.site = nil
  end

  # left this here because Idk if its important or not

  # if @user_plan === -99 or limit_reached
  #
  #   products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])
  #
  #   product = products.select { |product| product['Id'] == 2 }[0]
  #
  #   unless product
  #
  #     response = {
  #         success: false,
  #         message: 'Error retrieving subscription plan'
  #     }
  #     # render json: response
  #
  #   end
  #
  #   price = product['PlanPrice']
  #
  #   cardId = 0
  #   current_year = Date.today.strftime('%Y')
  #   current_month = Date.today.strftime('%m')
  #   creditCardId = Infusionsoft.data_query('CreditCard',
  #                                          100,
  #                                          0,
  #                                          {'ContactId' => user.clientid, 'ExpirationYear' => '~>=~' + current_year, 'Status' => 3},
  #                                          [:Id, :ContactId, :ExpirationMonth, :ExpirationYear]
  #   ).each do |creditCard|
  #
  #     if Integer(creditCard['ExpirationYear']) == Integer(current_year)
  #       if Integer(creditCard['ExpirationMonth']) >= Integer(current_month)
  #
  #         cardId = creditCard['Id']
  #       end
  #     else
  #
  #       cardId = creditCard['Id']
  #       puts cardId
  #     end
  #   end
  #
  #   puts cardId
  #
  #   if (cardId == 0)
  #
  #     response = {
  #         success: false,
  #         message: 'Error retrieving card'
  #     }
  #     # render json: response
  #
  #   else
  #
  #     subscription_id = Infusionsoft.invoice_add_recurring_order(user.clientid, true, 2, 4, cardId, 0, 0)
  #
  #
  #     invoice_id = Infusionsoft.invoice_create_invoice_for_recurring(subscription_id)
  #
  #     upgrade_response = Infusionsoft.invoice_charge_invoice(invoice_id, "Automatic Upgrade to 1000 Subscriber Tier", cardId, 4, false)
  #
  #     if upgrade_response[:Successful]
  #       # Tag for 1000 sub tier level plan
  #       new_tier_level_tag = 106
  #
  #       # Tags to remove from user
  #       trial_ended_tag = -99
  #       failed_payment_tag = 120
  #
  #       # Remove Tags from user for failed payment and Trial ended
  #       Infusionsoft.contact_remove_from_group(user.clientid, trial_ended_tag)
  #       Infusionsoft.contact_remove_from_group(user.clientid, failed_payment_tag)
  #
  #
  #       # Add tag to user for 1000 subscribers tier level
  #       Infusionsoft.contact_add_to_group(user.clientid, new_tier_level_tag)
  #
  #
  #       response = {
  #           success: true,
  #           message: 'Subscription Added!',
  #           response: upgrade_response
  #       }
  #     else
  #       response = {
  #           success: false,
  #           message: 'Invoice charge failed',
  #           response: upgrade_response
  #       }
  #     end
  #
  #
  #
  #   end
  #
  #   render json: response and return
  #
  #
  # end

end