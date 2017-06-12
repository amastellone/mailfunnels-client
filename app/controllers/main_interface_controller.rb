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
  # Renders the Account page of the MailFunnels App
  #
  #
  #
  def account

    # Get the Current App
    @app = MailfunnelsUtil.get_app

  end


  def ajax_update_account_info

    # Access current app
    app = App.find(params[:id])
    # Save The App Info
    app.put('',{
                 :first_name => params[:first_name],
                 :last_name => params[:last_name],
                 :email => params[:email],
                 :street_address => params[:street_address],
                 :city => params[:city],
                 :zip => params[:zip],
                 :state => params[:state],
                 :from_email => params[:from_email],
                 :from_name => params[:from_name],
                 :company_name => params[:company_name]
    })

    final_json = JSON.pretty_generate(result = {
        :success => true
    })

    # Return JSON response
    render json: final_json



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

    # Otherwise get list of all Apps
    @apps = App.all


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

    # Create new Subscriber instance
    subscriber = Subscriber.new

    # Update the Attributes for the Subscriber
    subscriber.app_id = params[:app_id]
    subscriber.first_name = params[:first_name]
    subscriber.last_name = params[:last_name]
    subscriber.email = params[:email]
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

    # Otherwise, create new Unsubscriber and Delete Subscriber
    unsubscriber = Unsubscriber.new
    unsubscriber.app_id = subscriber.app_id
    unsubscriber.first_name = subscriber.first_name
    unsubscriber.last_name = subscriber.last_name
    unsubscriber.email = subscriber.email

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
    today_subscribers = Subscriber.where(app_id: @app.id, day: 1 ).size
    week_subscribers = Subscriber.where(app_id: @app.id, week: 1 ).size
    month_subscribers = Subscriber.where(app_id: @app.id, month: 1 ).size

    # Unsubscriber Values
    today_unsubscribers = Unsubscriber.where(app_id: @app.id, day: 1 ).size
    week_unsubscribers = Unsubscriber.where(app_id: @app.id, week: 1 ).size
    month_unsubscribers = Unsubscriber.where(app_id: @app.id, month: 1 ).size

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
  # emails: Array of emails sent to subscriber

  def ajax_load_subscriber_info

    # Get the Subscriber from list
    subscriber = Subscriber.find(params[:subscriber_id])
    subscriber_emails = EmailJob.where(subscriber_id: params[:subscriber_id], sent: 1)




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


    data = {

        :id => subscriber.id,
        :first_name => subscriber.first_name,
        :last_name => subscriber.last_name,
        :email => subscriber.email,
        :revenue => subscriber.revenue,
        :total_emails => subscriber_emails.size,
        :emails => temp.to_json

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
