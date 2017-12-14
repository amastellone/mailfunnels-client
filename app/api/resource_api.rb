class ResourceApi < Grape::API
  prefix 'api'
  format :json

  def initialize
    super
  end

  # Apps Resource API
  # -----------------
  resource :apps do
    # Get Routes
    # ----------------
    get do
      App.where(params)
    end

    route_param :id do
      get do
        App.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      App.create! params
    end

    put ':id' do
      App.find(params[:id]).update(params)
    end

    put do
      App.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      App.find(params[:id]).destroy
    end

  end

  # Users Resource API
  # ---------------------
  resource :users do
    # Get Routes
    # ----------------

    get do
      User.where(params)
    end

    route_param :id do
      get do
        User.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------

    # creates new User
    # POST /user
    post do
      User.create! params
    end

    put ':id' do
      User.find(params[:id]).update(params)
    end

    put do
      User.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      User.find(params[:id]).destroy
    end

  end

  # Hooks Resource API
  # ------------------
  resource :hooks do
    # Get Routes
    # ----------------

    get do
      Hook.where(params)
    end

    route_param :id do
      get do
        Hook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Hook.create! params
    end

    put ':id' do
      Hook.find(params[:id]).update(params)
    end

    put do
      Hook.update(params)
    end


  end


  # Funnels Resource API
  # --------------------
  resource :funnels do
    # Get Routes
    # ----------------
    get do
      Funnel.where(params)
    end


    # GET funnels/:funnel_id
    route_param :funnel_id do
      get do
        Funnel.find(params[:funnel_id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Funnel.create! params
    end

    put ':id' do
      Funnel.find(params[:id]).update(params)
    end

    put do
      Funnel.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      Funnel.find(params[:id]).destroy
    end


  end


  # Triggers Resource API
  # ---------------------
  resource :triggers do
    # Get Routes
    # ----------------

    get do
      Trigger.where(params)
    end

    route_param :id do
      get do
        Trigger.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------

    # creates new Trigger
    # POST /triggers
    post do
      Trigger.create! params
    end

    put ':id' do
      Trigger.find(params[:id]).update(params)
    end

    put do
      Trigger.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      Trigger.find(params[:id]).destroy
    end

  end

  # Links Resource API
  # ------------------
  resource :links do
    # Get Routes
    # ----------------

    get do
      Link.where(params)
    end

    route_param :id do
      get do
        Link.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Link.create! params
    end

    put ':id' do
      Link.find(params[:id]).update(params)
    end

    put do
      Link.update(params)
    end

  end


  # Nodes Resource API
  # ------------------
  resource :nodes do
    # Get Routes
    # ----------------

    get do
      Node.where(params)
    end

    route_param :id do
      get do
        Node.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      Node.create! params
    end

    put ':id' do
      Node.find(params[:id]).update(params)
    end

    put do
      Node.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      Node.find(params[:id]).destroy
    end

  end


  # EmailList Resource API
  # ----------------------
  resource :email_lists do
    # Get Routes
    # ----------------
    get do
      EmailList.where(params)
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    route_param :id do
      get do
        EmailList.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailList.create! params
    end

    put ':id' do
      EmailList.find(params[:id]).update(params)
    end

    put do
      EmailList.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      EmailList.find(params[:id]).destroy
    end

  end

  # EmailTemplate Resource API
  # --------------------------
  resource :email_templates do
    # Get Routes
    # ----------------
    get do
      EmailTemplate.where(params)
    end

    route_param :id do
      get do
        EmailTemplate.find(params[:id])
      end
      put do
        EmailTemplate.find(params[:id]).update(params)
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailTemplate.create! params
    end

    put ':id' do
      EmailTemplate.find(params[:id]).update(params)
    end

    put do
      EmailTemplate.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      EmailTemplate.find(params[:id]).destroy
    end

  end

  # Email Template Hyperlinks Resource API
  # --------------------
  resource :template_hyperlinks do
    # Get Routes
    # ----------------
    get do
      TemplateHyperlink.where(params)
    end


    # GET funnels/:funnel_id
    route_param :funnel_id do
      get do
        TemplateHyperlink.find(params[:funnel_id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      TemplateHyperlink.create! params
    end

    put ':id' do
      TemplateHyperlink.find(params[:id]).update(params)
    end

    put do
      TemplateHyperlink.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      TemplateHyperlink.find(params[:id]).destroy
    end


  end


  # CapturedHooks Resource API
  # --------------------------
  resource :captured_hooks do
    # Get Routes
    # ----------------

    get do
      if params[:day]
        CapturedHook.where(app_id: params[:app_id], created_at: 24.hours.ago..Time.current)
      elsif params[:week]
        CapturedHook.where(app_id: params[:app_id], created_at: 7.days.ago..Time.current)
      elsif params[:month]
        CapturedHook.where(app_id: params[:app_id], created_at: 30.days.ago..Time.current)
      else
        CapturedHook.where(params)
      end
    end

    route_param :id do
      get do
        CapturedHook.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      CapturedHook.create! params
    end

    put ':id' do
      CapturedHook.find(params[:id]).update(params)
    end

    put do
      CapturedHook.update(params)
    end


  end

  # Subscriber Resource API
  # ------------------------
  resource :subscribers do

    # Get Routes
    # ----------------
    get do
      if params[:day]
        Subscriber.where(app_id: params[:app_id], created_at: 24.hours.ago..Time.current)
      elsif params[:week]
        Subscriber.where(app_id: params[:app_id], created_at: 7.days.ago..Time.current)
      elsif params[:month]
        Subscriber.where(app_id: params[:app_id], created_at: 30.days.ago..Time.current)
      else
        Subscriber.where(params)
      end
    end

    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end


    route_param :id do
      get do
        Subscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Subscriber.create! params
    end

    put ':id' do
      Subscriber.find(params[:id]).update(params)
    end

    put do
      Subscriber.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      Subscriber.find(params[:id]).destroy
    end

  end



  # Unsubscriber Resource API
  # ------------------------
  resource :unsubscribers do
    # Get Routes
    # ----------------
    get do
      if params[:day]
        Unsubscriber.where(app_id: params[:app_id], created_at: 24.hours.ago..Time.current)
      elsif params[:week]
        Unsubscriber.where(app_id: params[:app_id], created_at: 7.days.ago..Time.current)
      elsif params[:month]
        Unsubscriber.where(app_id: params[:app_id], created_at: 30.days.ago..Time.current)
      else
        Unsubscriber.where(params)
      end
    end

    route_param :id do
      get do
        Unsubscriber.find(params[:id])
      end
    end


    route_param :id do
      get do
        Unsubscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      Unsubscriber.create! params
    end

    put ':id' do
      Unsubscriber.find(params[:id]).update(params)
    end

    put do
      Unsubscriber.update(params)
    end
  end




  # EmailListSubscriber Resource API
  # ------------------------
  resource :email_list_subscribers do
    # Get Routes
    # ----------------
    get do
      EmailListSubscriber.where(params)
    end

    route_param :id do
      get do
        EmailListSubscriber.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      EmailListSubscriber.create! params
    end

    put ':id' do
      EmailListSubscriber.find(params[:id]).update(params)
    end

    put do
      EmailListSubscriber.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      EmailListSubscriber.find(params[:id]).destroy
    end

  end

  # EmailJobResource API
  # ------------------------
  resource :email_jobs do
    # Get Routes
    # ----------------
    get do
      if params[:day]

        if params[:sent]
          EmailJob.where(app_id: params[:app_id], sent: 1, created_at: 24.hours.ago..Time.current)
        elsif params[:opened]
          EmailJob.where(app_id: params[:app_id], opened: 1, created_at: 24.hours.ago..Time.current)
        elsif params[:clicked]
          EmailJob.where(app_id: params[:app_id], clicked: 1, created_at: 24.hours.ago..Time.current)
        end

      elsif params[:week]

        if params[:sent]
          EmailJob.where(app_id: params[:app_id], sent: 1, created_at: 7.days.ago..Time.current)
        elsif params[:opened]
          EmailJob.where(app_id: params[:app_id], opened: 1, created_at: 7.days.ago..Time.current)
        elsif params[:clicked]
          EmailJob.where(app_id: params[:app_id], clicked: 1, created_at: 7.days.ago..Time.current)
        end

      elsif params[:month]

        if params[:sent]
          EmailJob.where(app_id: params[:app_id], sent: 1, created_at: 30.days.ago..Time.current)
        elsif params[:opened]
          EmailJob.where(app_id: params[:app_id], opened: 1, created_at: 30.days.ago..Time.current)
        elsif params[:clicked]
          EmailJob.where(app_id: params[:app_id], clicked: 1, created_at: 30.days.ago..Time.current)
        end

      else
        EmailJob.where(params)
      end
    end

    route_param :id do
      get do
        EmailJob.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      emailJob = EmailJob.create params
      node = Node.find(emailJob.node_id)
      if node.delay_unit == 1
        SendEmailJob.set(wait: node.delay_time.minutes).perform_later(emailJob.id)
      elsif node.delay_unit == 2
        SendEmailJob.set(wait: node.delay_time.hours).perform_later(emailJob.id)
      elsif node.dela7_unit ==3
        SendEmailJob.set(wait: node.delay_time.days).perform_later(emailJob.id)
      end

    end

    put ':id' do
      EmailJob.find(params[:id]).update(params)
    end

    put do
      EmailJob.update(params)
    end
  end

  # BatchEmailJobResource API
  # ------------------------
  resource :batch_email_jobs do
    # Get Routes
    # ----------------
    get do
      BatchEmailJob.where(params)
    end

    route_param :id do
      get do
        BatchEmailJob.find(params[:id])
      end
    end

    # Post/Put Routes
    # ----------------
    post do
      batchJob = BatchEmailJob.create params
      ProcessBroadcastJob.set(wait:1.minutes).perform_later(batchJob.id)
      batchJob
    end

    put ':id' do
      BatchEmailJob.find(params[:id]).update(params)
    end

    put do
      BatchEmailJob.update(params)
    end
  end

  # BroadcastLists Resource API
  # -----------------
  resource :broadcast_lists do

    # Get Routes
    # ----------------
    get do
      BroadcastList.where(params)
    end

    route_param :id do
      get do
        BroadcastList.find(params[:id])
      end
    end


    # Post/Put Routes
    # ----------------
    post do
      BroadcastList.create! params
    end

    put ':id' do
      BroadcastList.find(params[:id]).update(params)
    end

    put do
      BroadcastList.update(params)
    end

    # DELETE Route
    # ------------
    delete ':id' do
      BroadcastList.find(params[:id]).destroy
    end

  end


end