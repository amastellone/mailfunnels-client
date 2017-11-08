require 'csv'
require 'date'

class MainInterfaceController < ShopifyApp::AuthenticatedController

  # Page Render Function
  # --------------------
  # Renders the Home Page of the MailFunnels App
  #
  #
  def index

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # If the User is not an admin redirect to error page
    if @app.is_disabled and @app.is_disabled === 1
      redirect_to '/account_disabled'
    end

    user = @app.user

    @user_plan = MailFunnelsUser.get_user_plan(user.clientid)

    @subs_left = MailFunnelsUser.get_remaining_subs(user.clientid)

    @num_email_sent = EmailJob.where(app_id: @app.id, sent: 1).size

    @num_email_opened = EmailJob.where(app_id: @app.id, opened: 1).size

    @num_email_clicked = EmailJob.where(app_id: @app.id, clicked: 1).size


    # Calculate the the total revenue for the user
    @total_revenue = 0.0

    # Loop through all funnels and sum up the total revenue
    funnels = Funnel.where(app_id: @app.id)
    funnels.each do |funnel|
      @total_revenue += funnel.num_revenue.to_f
    end

  end


  # Page Render Function
  # --------------------
  # Renders the All Subscribers Page which
  # contains a table of all subscribers on for the
  # current app
  #
  def all_refund_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id, initial_ref_type: 2)

    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

  end

  # Page Render Function
  # --------------------
  # Renders the All Subscribers Page which
  # contains a table of all subscribers on for the
  # current app
  #
  def all_abandoned_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id, initial_ref_type: 3)

    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

  end

  # Page Render Function
  # --------------------
  # Renders the All Subscribers Page which
  # contains a table of all subscribers on for the
  # current app
  #
  def all_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get all subscribers instances for the app
    @subscribers = Subscriber.where(app_id: @app.id)


    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)


  end


  # Page Render Function
  # --------------------
  # Renders the List Subscribers Page which
  # contains a table of all the subscribers on the
  # list provided by id in params
  #
  # PARAMETERS
  # ----------
  # list_id: ID of the list we want to display subscribers for
  #
  def list_subscribers

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get the current list
    @subscribers = EmailListSubscriber.where(email_list_id: params[:list_id])

    # Get all Email List
    @list = EmailList.find(params[:list_id])

    # Get all Email Templates
    @templates = EmailTemplate.where(app_id: @app.id)

    # Get all Funnels associated with current email list
    @funnels = Funnel.where(email_list_id: params[:list_id])

    # Get number of broadcast lists associated with current email list
    @num_broadcasts = BroadcastList.where(email_list_id: params[:list_id]).size


    @user_plan = MailFunnelsUser.get_user_plan(@app.user.clientid)


  end


  # Page Render Function
  # --------------------
  # Renders the Admin Panel for MailFunnels App
  # If user is an Admin, they can disable users from
  # using the app on this page
  #
  #
  def admin_panel

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # If the User is not an admin redirect to error page
    if !@app.is_admin or @app.is_admin === 0
      redirect_to '/error_page'
    end


    # Otherwise get list of all Users
    @users = User.all


  end


  # Page Render Function
  # --------------------
  # Renders the Error Page for when user tries to
  # access the admin panel and is not an admin
  #
  #
  def error_page

    #Get the Current App
    @app = MailfunnelsUtil.get_app

  end

  # Page Render Function
  # --------------------
  # Renders the Account Disabled Page
  #
  #
  def account_disabled

  end


  # Page Render Function
  # --------------------
  # Renders the Trial User access denied page
  #
  #
  def trial_page_disabled

    #Get the Current App
    @app = MailfunnelsUtil.get_app

  end


  # Page Render Function
  # --------------------
  # Renders the Account page of the MailFunnels App
  #
  #
  def account

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Get Current MailFunnels Plan For User
    @plan = MailFunnelsUser.get_user_plan(@app.user.clientid)

    # Get The Current User
    @user = @app.user

    @app = MailfunnelsUtil.get_app


  end


  # Page Render Function
  # --------------------
  # Renders the Support Page which contains link
  # to MailFunnels Support and youtube videos which
  # show users how to use features
  #
  def support

    # Get the Current App
    @app = MailfunnelsUtil.get_app

  end


  def ajax_update_account_info

    # Get the current App
    app = App.find(params[:id])

    # If no app
    unless app
      response = {
          success: false,
          message: 'App not found!'
      }

      render json: response and return
    end

    # Get Current User
    user = app.user

    # Change User Info in DB
    user.put('', {
        :first_name => params[:first_name],
        :last_name => params[:last_name],
        :email => params[:email],
    })

    # Update Infusionsoft Contact
    Infusionsoft.contact_update(user.clientid, {
        :FirstName => params[:first_name],
        :LastName => params[:last_name],
        :Email => params[:email]
    })

    response = {
        success: true,
        message: 'User Updated!'
    }

    render json: response


  end


  def ajax_update_email_info

    # Access current app
    app = App.find(params[:id])
    # user = User.find(app.user_id)

    unless app
      response = {
          success: false,
          message: 'App not found'
      }

      render json: response and return

    end

    app.put('', {
        :from_name => params[:from_name]
    })

    # user.put('', {
    #     :has_mailfunnel_watermark => params[:watermark]
    # })


    response = {
        success: true,
        message: 'From Name Successflully Set'
    }

    # Return JSON response
    render json: response
  end


  # USED WITH AJAX
  # --------------
  # Creates a new subscribers for the app
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app
  # first_name: First Name of the Subscriber
  # last_name: Last Name of the Subscriber
  # email: Email address of the Subscriber
  #
  def ajax_create_subscriber

    # Get Current App
    app = App.find(params[:app_id])

    # If no app found return error response
    unless app
      response = {
          success: false,
          type: -1,
          message: 'Could not find current App'
      }
      render json: response and return
    end

    # Get Current User Remaining Subs
    subs_remaining = MailFunnelsUser.get_remaining_subs(app.user.clientid)

    # If no more subscribers left in plan, return error response
    if subs_remaining < 1
      response = {
          success: false,
          type: 0,
          message: 'No more subscribers left'
      }
      render json: response and return
    end


    # Create new Subscriber instance
    subscriber = Subscriber.new

    # Update the Attributes for the Subscriber
    subscriber.app_id = params[:app_id]
    subscriber.first_name = params[:first_name]
    subscriber.last_name = params[:last_name]
    subscriber.email = params[:email]
    subscriber.initial_ref_type = 0
    subscriber.revenue = 0.0


    # Save and verify Subscriber and return correct JSON response
    if subscriber.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  # USED WITH AJAX
  # --------------
  # Removes the Subscriber and adds them to the
  # Unsubscriber list in the DB
  #
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current app we are using
  # subscriber_id: ID of the subscriber we are removing
  #
  def ajax_delete_subscriber

    # Get the Subscriber from the DB
    subscriber = Subscriber.find(params[:subscriber_id])

    # If subscriber does not exist, return error response
    if subscriber.nil?
      response = {
          success: false,
          message: 'Subscriber Does not exist in DB!'
      }
      render json: response
    end
    email_list_subscriber = EmailListSubscriber.where(subscriber_id: subscriber.id).first

    # Otherwise, create new Unsubscriber and Delete Subscriber
    unsubscriber = Unsubscriber.new
    unsubscriber.app_id = subscriber.app_id
    unsubscriber.first_name = subscriber.first_name
    unsubscriber.last_name = subscriber.last_name
    unsubscriber.email = subscriber.email
    unsubscriber.initial_ref_type = subscriber.initial_ref_type
    if !email_list_subscriber.nil?
      unsubscriber.email_list_id = email_list_subscriber.email_list_id
    end


    # If error saving unsubscriber, then return error response
    if !unsubscriber.save!
      response = {
          success: false,
          message: 'Could not save unsubscriber!'
      }
      render json: response
    end

    # Now remove the Subscriber from DB
    subscriber.destroy

    # Return Success Response
    response = {
        success: true,
        message: 'Subscriber Deleted!'
    }
    render json: response

  end

  def ajax_remove_from_list
    subscriber = Subscriber.find(params[:subscriber_id])
    list = EmailList.find(params[:email_list_id])
    list_subscriber = EmailListSubscriber.where(subscriber_id: subscriber.id, email_list_id: list.id).first


    if list_subscriber
      list_subscriber.destroy
    end


  end


  # USED WITH AJAX
  # --------------
  # Sends a batch email to all subscribers on that list
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the current App
  # email_template_id: ID of the Email Template to send to subscribers
  # email_list_id: ID of the email list to send batch email to
  #
  def ajax_create_batch_email

    # Create new Batch Email
    batch = BatchEmailJob.new

    # Update the Attributes for the Batch Email Jon
    batch.app_id = params[:app_id]
    batch.email_template_id = params[:email_template_id]
    batch.email_list_id = params[:email_list_id]

    if batch.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json


  end


  def ajax_load_time_data

    # Get the Current App
    @app = MailfunnelsUtil.get_app

    # Subscriber Values
    today_subscribers = Subscriber.where(app_id: @app.id, day: 1).size
    week_subscribers = Subscriber.where(app_id: @app.id, week: 1).size
    month_subscribers = Subscriber.where(app_id: @app.id, month: 1).size

    # Unsubscriber Values
    today_unsubscribers = Unsubscriber.where(app_id: @app.id, day: 1).size
    week_unsubscribers = Unsubscriber.where(app_id: @app.id, week: 1).size
    month_unsubscribers = Unsubscriber.where(app_id: @app.id, month: 1).size

    # Emails Sent Values
    today_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, day: 1).size
    week_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, week: 1).size
    month_emails_sent = EmailJob.where(app_id: @app.id, sent: 1, month: 1).size

    # Emails Opened Values
    today_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, day: 1).size
    week_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, week: 1).size
    month_emails_opened = EmailJob.where(app_id: @app.id, opened: 1, month: 1).size

    # Emails Clicked Values
    today_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, day: 1).size
    week_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, week: 1).size
    month_emails_clicked = EmailJob.where(app_id: @app.id, clicked: 1, month: 1).size

    # Revenue Stats
    today_revenue = 0
    week_revenue = 0
    month_revenue = 0
    CapturedHook.where(app_id: @app.id, day: 1).each do |hook|
      today_revenue = today_revenue + hook.revenue.to_f
    end
    CapturedHook.where(app_id: @app.id, week: 1).each do |hook|
      week_revenue = week_revenue + hook.revenue.to_f
    end
    CapturedHook.where(app_id: @app.id, month: 1).each do |hook|
      month_revenue = month_revenue + hook.revenue.to_f
    end


    data = {
        today_subscribers: today_subscribers,
        week_subscribers: week_subscribers,
        month_subscribers: month_subscribers,
        today_unsubscribers: today_unsubscribers,
        week_unsubscribers: week_unsubscribers,
        month_unsubscribers: month_unsubscribers,
        today_emails_sent: today_emails_sent,
        week_emails_sent: week_emails_sent,
        month_emails_sent: month_emails_sent,
        today_emails_opened: today_emails_opened,
        week_emails_opened: week_emails_opened,
        month_emails_opened: month_emails_opened,
        today_emails_clicked: today_emails_clicked,
        week_emails_clicked: week_emails_clicked,
        month_emails_clicked: month_emails_clicked,
        today_revenue: ActionController::Base.helpers.number_to_currency(today_revenue),
        week_revenue: ActionController::Base.helpers.number_to_currency(week_revenue),
        month_revenue: ActionController::Base.helpers.number_to_currency(month_revenue),

    }


    # Return data as JSON
    render json: data


  end


  # USED WITH AJAX
  # --------------
  # Shows Info Pertaining to subscriber
  #
  # PARAMETERS
  # ----------
  # ID: ID of the subscriber
  # first_name: First name of the subscriber
  # last_name: Last name of the subscriber
  # email: Email of the subscriber
  # revenue: Revenue from the subscriber
  #

  def ajax_load_subscriber_info

    # Get the Subscriber from list
    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber_emails = EmailJob.where(subscriber_id: params[:subscriber_id])
    email_lists = EmailListSubscriber.where(subscriber_id: params[:subscriber_id])

    email_list = Array.new
    temp = Array.new

    subscriber_emails.each do |se|
      email = {
          :email_id => se.id,
          :name => se.email_template.name,
          :clicked => se.clicked,
          :opened => se.opened,
      }

      temp.push(email)

    end

    email_lists.each do |el|
      list = {
          :email_list_id => el.email_list_id,
          :email_list_name => el.email_list.name,
      }

      email_list.push(list)
    end

    data = {

        :id => subscriber.id,
        :first_name => subscriber.first_name,
        :last_name => subscriber.last_name,
        :email => subscriber.email,
        :revenue => subscriber.revenue,
        :total_emails => subscriber_emails.size,
        :emails => temp.to_json,
        :total_lists => email_lists.size,
        :lists => email_list.to_json,

    }

    # Return data as JSON
    render json: data

  end


  # USED WITH AJAX
  # --------------
  # Enables the app if the user is an admin
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the app that we are enabling
  #
  def ajax_enable_app

    # Get the Current App
    current_app = MailfunnelsUtil.get_app

    # If the User is not an admin return error response
    if !current_app.is_admin or current_app.is_admin === 0
      response = {
          success: false,
          message: 'You do not have admin privileges!'
      }
      render json: response
    end

    # Get the App we are disabling
    app = App.find(params[:app_id])

    # Set disables status to 0
    app.is_disabled = 0

    app.put('', {
        :is_disabled => app.is_disabled,
    })


    # Return Success Response
    response = {
        success: true,
        message: 'App Enabled!'
    }
    render json: response


  end

  def ajax_upgrade_plan

    @app = MailfunnelsUtil.get_app
    user = User.find(@app.user_id)
    puts "-----1-----"
    puts user


    plan = MailFunnelsUser.get_user_plan(user.clientid)
    puts "2"
    recurring_orders = Infusionsoft.data_query('RecurringOrderWithContact', 100, 0, {}, [:Id, :ContactId])
    puts "3"

    recurring = recurring_orders.select {|recurring| recurring['ContactId'] == user.clientid}[0]

    order = recurring['Id']
    puts "Recurring Order ID: #{order}"


    puts "4"


    plan_id = MailFunnelsUser.get_user_plan(user.clientid)

    products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])

    product = products.select {|product| product['Id'] == params[:subscription_id].to_i}[0]


    unless product
      response = {
          success: false,
          message: 'Error retrieving subscription plan'
      }
      render json: response
    end

    price = product['PlanPrice']

    creditCardId = Infusionsoft.invoice_locate_existing_card(user.clientid, params[:last_four])

    if (creditCardId == 0)
      response = {
          success: false,
          message: 'Error retrieving card'
      }
      render json: response
    end


    invoice = Infusionsoft.invoice_add_subscription(user.clientid,
                                                    false,
                                                    params[:subscription_id],
                                                    1,
                                                    price,
                                                    false,
                                                    4,
                                                    creditCardId,
                                                    0,
                                                    0
    )


    tag = -1

    if params[:subscription_id].to_i == 2
      tag=106
    elsif params[:subscription_id].to_i == 4
      tag=108

    elsif params[:subscription_id].to_i == 6
      tag=110

    elsif params[:subscription_id].to_i == 8
      tag=112

    elsif params[:subscription_id].to_i == 10
      tag=114

    elsif params[:subscription_id].to_i == 12
      tag=116

    elsif params[:subscription_id].to_i == 14
      tag=118
    end

    Infusionsoft.contact_remove_from_group(user.clientid, plan)


    puts "--------------TEST---------------"

    Infusionsoft.contact_add_to_group(user.clientid, tag)
    Infusionsoft.contact_remove_from_group(user.clientid, plan_id)


    Infusionsoft.invoice_delete_subscription(order)

    response = {
        success: true,
        message: 'Subscription Added!'
    }

    render json: response

  end


  # USED WITH AJAX
  # --------------
  # Disables the app if the user is an admin
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the app that we are disabling
  #
  def ajax_disable_app

    # Get the Current App
    current_app = MailfunnelsUtil.get_app

    # If the User is not an admin return error response
    if !current_app.is_admin or current_app.is_admin === 0
      response = {
          success: false,
          message: 'You do not have admin privileges!'
      }
      render json: response
    end

    # Get the App we are disabling
    app = App.find(params[:app_id])

    # Set disables status to 1
    app.is_disabled = 1

    app.put('', {
        :is_disabled => app.is_disabled,
    })


    # Return Success Response
    response = {
        success: true,
        message: 'App Disabled!'
    }
    render json: response


  end

  def import_csv
    puts "import csv"
    if request.post?
      puts "1"
      if params[:csv].present?
        puts "2"
        app = MailfunnelsUtil.get_app
        puts "3"
        csv_text = params[:csv].read
        puts "4"
        csv = CSV.parse(csv_text, :headers => true)
        puts "5"

        if params[:list_id].present?
          puts "List Id Present"
          csv.each do |row|
            h = row.to_hash
            h.merge!(app_id: app.id)
            h.merge!(revenue: 0)
            h.merge!(initial_ref_type: 0)
            subscriber = Subscriber.create!(h)
            puts "subscriber created"

            list_subscriber = EmailListSubscriber.new
            list_subscriber.app_id = app.id
            list_subscriber.email_list_id = params[:list_id]
            list_subscriber.subscriber_id = subscriber.id
            list_subscriber.save!
          end

        else
          puts "List Id Not Present"
          csv.each do |row|
            h = row.to_hash
            h.merge!(app_id: app.id)
            h.merge!(revenue: 0)
            h.merge!(initial_ref_type: 0)
            Subscriber.create!(h)
            puts "subscriber created"
          end
        end


        redirect_to :controller => 'email', :action => 'lists'
      else
        puts "=========FAILED======="
        redirect_to :controller => 'email', :action => 'lists'
      end
    end
  end


  def ajax_add_to_list
    subscriber = EmailListSubscriber.new

    subscriber.app_id = params[:app_id]
    subscriber.email_list_id = params[:list_id]
    subscriber.subscriber_id = params[:subscriber_id]

    # Save and verify Subscriber and return correct JSON response
    if subscriber.save!
      final_json = JSON.pretty_generate(result = {
          :success => true
      })
    else
      final_json = JSON.pretty_generate(result = {
          :success => false
      })
    end

    # Return JSON response
    render json: final_json

  end


  # USED WITH AJAX
  # --------------
  # Changes the users password
  #
  # PARAMETERS
  # ----------
  # app_id: ID of the Current App
  # password: New Password
  #
  def ajax_change_password

    # Get the current App
    app = App.find(params[:app_id])

    # If no app
    unless app
      response = {
          success: false,
          message: 'App not found!'
      }

      render json: response and return
    end

    # Get Current User
    user = app.user

    # Change User Password in DB
    user.password = params[:password]

    # Update Infusionsoft Contact
    Infusionsoft.contact_update(user.clientid, {
        :Password => params[:password]
    })

    # Save User to DB
    user.save

    response = {
        success: true,
        message: 'Password Updated!'
    }

    render json: response
  end

  def ajax_save_edited_list_info
    list = EmailList.find(params[:list_id])

    list.name = params[:name]
    list.description = params[:description]

    list.put('', {
        :name => list.name,
        :description => list.description,
    })
    # Return Success Response
    response = {
        success: true,
        message: 'List Updated!'
    }
    render json: response


  end

  def ajax_delete_email_list


    # Get the list from the database
    list = EmailList.find(params[:list_id])

    # Get subscribers that belong to current Email List
    list_subscriber = EmailListSubscriber.where(email_list_id: list.id)


    list_subscriber.each do |subscriber|

      global_subscriber = Subscriber.find(subscriber.subscriber_id)

      global_subscriber.destroy

    end


    list.put('', {
        :active => 1
    })


  end

  # ajax_cancel_subscription
  # --------------------------------------------
  # Cancels the subscription by setting the last_bill_date to today in the infusionsoft database
  #
  # Takes no params

  def ajax_cancel_subscription
    puts "============= Starting ajax cancel ================"
    # retrieve the subscription from infusionsoft
    recurring_order = Infusionsoft.data_query('RecurringOrder', 100, 0, {:ContactId=>287}, [:Id, :EndDate, :ContactId]).first

    puts recurring_order['EndDate'].to_date


    # # check if we found the recurring order in infusionsoft's db
    # if recurring_order.nil?
    #   puts "ERROR - unable to retieve the recurring order with ContactId = 287"
    #   puts "---- Returning (FAILURE) ----"
    #   puts "======================="
    #   # Return Failure Response
    #   response = {
    #       success: false,
    #       message: 'Failed to retrieve recurring order from infusionsoft database'
    #   }
    #   render json: response and return
    # else
    #   puts "INFO - successfully retrieved recurring order with with id = #{recurring_order[Id]}"
    # end

    # puts "INFO - updating infusionsoft database to cancel the subscription, current EndDate = '#{recurring_order['EndDate']}'"
    #
    # # update the last bill date on the subscription to today
    # row_id = Infusionsoft.data_update('RecurringOrder',recurring_order['Id'], {:EndDate => Time.now.to_s(:db)})
    #
    # puts "========="
    # puts "row_id = #{row_id}"
    # puts "========="
    #
    # recurring_order = Infusionsoft.data_query('RecurringOrder', 100, 0, {:ContactId=>287}, [:Id, :EndDate,:ContactId]).first
    #
    # puts "INFO - querying again. EndDate = '#{recurring_order['EndDate']}'"
    #
    # puts "DONEDONEDEONDONEDONE"
    return




    # check if we successfully canceled the subscription
    if row_id != recurring_order[:Id]
      puts "ERROR - there was an error updating the RecurringOrder table in infusionsoft"
      puts "---- Returning (FAILURE) ----"
      puts "======================="
      # Return Failure Response
      response = {
          success: false,
          message: 'Failed to update RecurringOrder in infusionsoft database'
      }
      render json: response and return
    else
      puts "INFO - successfully updated the Recurring order table in infusionsoft"
      puts "---- Returning (SUCCESS) ----"
      puts "======================="
      # Return Success Response
      response = {
          success: true,
          message: 'Successfully canceled subscription'
      }
      render json: response and return
    end







    # puts "======================="
    # puts "main_interface_controller :: ajax_cancel_subscription"
    #
    # # get the app of the user who made the request
    # current_app = MailfunnelsUtil.get_app
    #
    # # check if we successfully retrieved the app from the db
    # if current_app.nil?
    #   puts "ERROR - unable to retieve the app of the current user"
    #   puts "---- Returning  (FAILURE) ----"
    #   puts "======================="
    #   # Return Failure Response
    #   response = {
    #       success: false,
    #       message: 'Failed to retrieve current application from database'
    #   }
    #   render json: response and return
    # else
    #   puts "INFO - successfully retrieved application with id = #{current_app.id}"
    # end
    #
    # # get the user associated with the app
    # user = User.find(current_app.user_id)
    #
    # # check if we successfully retrieved the user from the db
    # if user.nil?
    #   puts "ERROR - unable to retieve the user with app_id = #{current_app.id}"
    #   puts "---- Returning  (FAILURE) ----"
    #   puts "======================="
    #   # Return Failure Response
    #   response = {
    #       success: false,
    #       message: 'Failed to retrieve current user from database'
    #   }
    #   render json: response and return
    # else
    #   puts "INFO - successfully retrieved user with id = #{user.id}"
    # end
    #
    # puts "INFO - querying infusionsoft with client_id = #{user.clientid}"
    #
    # # retrieve the subscription from infusionsoft
    # recurring_order = Infusionsoft.data_query('RecurringOrder', 100, 0, {:ContactId=>user.clientid}, [:Id, :EndDate]).first
    #
    # # check if we found the recurring order in infusionsoft's db
    # if recurring_order.nil?
    #   puts "ERROR - unable to retieve the recurring order with ContactId = #{user.clientid}"
    #   puts "---- Returning (FAILURE) ----"
    #   puts "======================="
    #   # Return Failure Response
    #   response = {
    #       success: false,
    #       message: 'Failed to retrieve recurring order from infusionsoft database'
    #   }
    #   render json: response and return
    # else
    #   puts "INFO - successfully retrieved recurring order with with id = #{recurring_order[:Id]}"
    # end
    #
    # puts "INFO - updating infusionsoft database to cancel the subscription, current EndDate = '#{recurring_order[:EndDate]}'"
    #
    # # update the last bill date on the subscription to today
    # row_id = Infusionsoft.data_update('RecurringOrder',recurring_order[:Id], {:EndDate => Time.now.to_s(:db)})
    #
    # # check if we successfully canceled the subscription
    # if row_id != recurring_order[:Id]
    #   puts "ERROR - there was an error updating the RecurringOrder table in infusionsoft"
    #   puts "---- Returning (FAILURE) ----"
    #   puts "======================="
    #   # Return Failure Response
    #   response = {
    #       success: false,
    #       message: 'Failed to update RecurringOrder in infusionsoft database'
    #   }
    #   render json: response and return
    # else
    #   puts "INFO - successfully updated the Recurring order table in infusionsoft"
    #   puts "---- Returning (SUCCESS) ----"
    #   puts "======================="
    #   # Return Success Response
    #   response = {
    #       success: true,
    #       message: 'Successfully canceled subscription'
    #   }
    #   render json: response and return
    # end

  end


  # def ajax_test
  #
  #   # @app = MailfunnelsUtil.get_app
  #   # user = User.find(@app.user_id)
  #   # puts "------ 1"
  #   # products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])
  #   #
  #   # product = products.select { |product| product['Id'] == 2 }[0]
  #   #
  #   #
  #   # unless product
  #   #   response = {
  #   #       success: false,
  #   #       message: 'Error retrieving subscription plan'
  #   #   }
  #   #   render json: response
  #   # end
  #   #
  #   # price = product['PlanPrice']
  #   # puts "------ 2"
  #   #
  #   # creditCardId = Infusionsoft.invoice_locate_existing_card(14, '1111')
  #   #
  #   # if (creditCardId == 0)
  #   #   response = {
  #   #       success: false,
  #   #       message: 'Error retrieving card'
  #   #   }
  #   #   render json: response
  #   # end
  #   #
  #   # puts "------ 3"
  #   #
  #   # subscription_id = Infusionsoft.invoice_add_subscription(14,
  #   #                                                 false,
  #   #                                                 2,
  #   #                                                 1,
  #   #                                                 price,
  #   #                                                 false,
  #   #                                                 4,
  #   #                                                         creditCardId,
  #   #                                                 0,
  #   #                                                 0
  #   # )
  #   #
  #   # puts "------ 4"
  #   #
  #   # invoice_id = Infusionsoft.invoice_create_invoice_for_recurring(subscription_id)
  #   # puts "------ 5"
  #   #
  #   # test_response = Infusionsoft.invoice_charge_invoice(invoice_id, "--TEST--", creditCardId, 4, false)
  #   #
  #   #
  #   #
  #   # tag = -1
  #   #
  #   # if params[:subscription_id].to_i == 2
  #   #   tag=106
  #   # elsif params[:subscription_id].to_i == 4
  #   #   tag=108
  #   #
  #   # elsif params[:subscription_id].to_i == 6
  #   #   tag=110
  #   #
  #   # elsif params[:subscription_id].to_i == 8
  #   #   tag=112
  #   #
  #   # elsif params[:subscription_id].to_i == 10
  #   #   tag=114
  #   #
  #   # elsif params[:subscription_id].to_i == 12
  #   #   tag=116
  #   #
  #   # elsif params[:subscription_id].to_i == 14
  #   #   tag=118
  #   # end
  #   #
  #   # # Infusionsoft.contact_add_to_group(25, tag)
  #
  #   @app = MailfunnelsUtil.get_app
  #   user = User.find(@app.user_id)
  #
  #   current_year = Date.today.strftime('%Y')
  #   current_month = Date.today.strftime('%m')
  #
  #
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
  #         response = {
  #             success: true,
  #             message: 'Card good',
  #             response: creditCard,
  #             response2: creditCard['Id']
  #         }
  #
  #         render json: response
  #         return
  #       end
  #     else
  #       response = {
  #           success: true,
  #           message: 'Card good',
  #           response: creditCard,
  #           response2: creditCard['Id']
  #       }
  #
  #       render json: response
  #       return
  #     end
  #   end
  #
  #   response = {
  #       success: false,
  #       message: 'no good cards',
  #       response: creditCardId
  #   }
  #
  #   render json: response
  #
  #
  #   # creditCardId = Infusionsoft.data_query('CreditCard', 100, 0, {'ContactId' => user.clientid, 'ExpirationYear' => '~>=~' + Date.today.strftime('%Y')}, [:Id, :ContactId, :ExpirationYear, :ExpirationMonth])
  #   # products = Infusionsoft.data_query('SubscriptionPlan', 100, 0, {}, [:Id, :PlanPrice])
  #
  #
  # end


  def form_page
    if request.post?
      if params[:name].present?
        flash[:notice] = "Created #{ params[:colour] } unicorn: #{ params[:name] }."
      else
        flash[:error] = "Name must be set."
      end
    end
  end

  def pagination
    @total_pages = 3
    @page = (params[:page].presence || 1).to_i
    @previous_page = "/pagination?page=#{ @page - 1 }" if @page > 1
    @next_page = "/pagination?page=#{ @page + 1 }" if @page < @total_pages
  end

end
