class AdminController < ApplicationController


  def admin_dashboard_stats

    # Get Number of Users
    num_users = User.count

    # Get App Statistics
    num_apps = App.count
    num_disabled_apps = App.where(is_disabled: 1).count
    num_active_apps = num_apps - num_disabled_apps


    # Get Subscriber Statistics
    num_subs = Subscriber.count
    num_unsubs = Unsubscriber.count

    # Get Number of Captured Hooks
    num_captured_hooks = CapturedHook.count

    # Get Number of Funnels
    num_funnels = Funnel.count

    num_email_sent = EmailJob.where(sent: 1).count

    num_email_opened = EmailJob.where(opened: 1).count

    num_email_clicked = EmailJob.where(clicked: 1).count


    # Calculate the the total revenue for the user
    total_revenue = 0.0

    # Loop through all funnels and sum up the total revenue
    Funnel.find_each do |funnel|
      total_revenue += funnel.num_revenue.to_f
    end

    response = {
        success: true,
        num_users: num_users,
        num_apps: num_apps,
        num_disabled_apps: num_disabled_apps,
        num_active_apps: num_active_apps,
        num_subs: num_subs,
        num_unsubs: num_unsubs,
        num_captured_hooks: num_captured_hooks,
        num_funnels: num_funnels,
        num_email_sent: num_email_sent,
        num_email_opened: num_email_opened,
        num_email_clicked: num_email_clicked
    }

    render json: response

  end


end
