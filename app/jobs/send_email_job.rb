require "erb"
require 'premailer'

class SendEmailJob < ApplicationJob
  @queue = :default

  def perform(job_id)

    job = EmailJob.where(id: job_id).first
    if job.nil? == false

      funnel = Funnel.find(job.funnel_id)
      if funnel.nil? == false
        trigger = Trigger.find(funnel.trigger_id)
      end
      @template = EmailTemplate.find(job.email_template_id)
      @subscriber = Subscriber.find(job.subscriber_id)
      node = Node.find(job.node_id)
      @app = App.find(job.app_id);
      if job.sent == 1
        puts "Email Already Sent to Subscriber"
      else

        @email_job = job
        check_out_url = 0

        if trigger.hook_id == 3
          puts "hook id = 3"
          if @template.has_checkout_url == 1 or @template.has_ac_holder == 1
            puts "template using checkout url"

            if @template.has_button
              puts "template has button"

              if @subscriber.abandoned_url != nil
                puts "subscriber abandoned url not nil"
                job.abandoned_url = @subscriber.abandoned_url
                check_out_url = 1
              else
                @template.has_button = 0
              end
            end
          end
        end

        @renderedhtml = "1"

        if @template.style_type == 1
          html = File.open("app/views/email/styles/mf-minimal_1.html.erb").read

          if @template.is_dynamic === 1

            puts "inside dynamic template"

            @email_content = RedCloth.new(Liquid::Template.parse(@template.html).render(
                'product_title' => job.product_title,
                'product_description' => job.product_description,
                'product_image' => job.product_image,
                'product_price' => job.product_price,
                'abandoned_checkout_url' => @subscriber.abandoned_url
            )).to_html

          else
            @email_content = RedCloth.new(Liquid::Template.parse(@template.html).render(
                'product_title' => "Product Name",
                'product_description' => "Product Description",
                'product_image' => 'https://s3-us-west-2.amazonaws.com/mailfunnels-dev/store_placeholder.png',
                'product_price' => '0.00',
                'abandoned_checkout_url' => @subscriber.abandoned_url
            )).to_html
          end

        else
          html = File.open("app/views/email/template.html.erb").read
        end

        ERB.new(html, 0, "", "@renderedhtml").result(binding)

        if @template.style_type === 1
          premailer = Premailer.new(@renderedhtml, { :warn_level => Premailer::Warnings::SAFE, :with_html_string => true})

          @renderedhtml = premailer.to_inline_css

        end

        if @app.from_name.nil?
          name = "Shop Admin"
        else
          name = @app.from_name
        end

        if @app.from_email.nil?
          email = "noreply@custprotection.com"
        else
          email = @app.from_email
        end

        client = Postmark::ApiClient.new('b650bfe2-d2c6-4714-aa2d-e148e1313e37', http_open_timeout: 60)
        response = client.deliver(
            :subject => @template.email_subject,
            :to => @subscriber.email,
            :from => name+' '+email,
            :html_body => @renderedhtml,
            :track_opens => 'true')


        if check_out_url == 1
          @subscriber.abandoned_url = nil
          @subscriber.save!
        end

        if trigger.nil? == false
          trigger.num_emails_sent = trigger.num_emails_sent+1
          trigger.save!
        end

        job.executed = true
        job.postmark_id = response[:message_id]
        job.sent = 1
        job.save!
      end

      link = Link.where(from_node: node.id).first
      if link.nil? == false
        nextNode = Node.where(id: link.to_node_id).first
        job = EmailJob.create(app_id: job.app_id,
                              funnel_id: funnel.id,
                              subscriber_id: job.subscriber_id,
                              executed: false,
                              node_id: link.to_node_id,
                              email_template_id: nextNode.email_template_id,
                              email_list_id: job.email_list_id,
                              sent: 0,
                              product_title: job.product_title,
                              product_description: job.product_description,
                              product_price: job.product_price,
                              product_image: job.product_image)

        if nextNode.delay_unit == 1
          SendEmailJob.set(wait: node.delay_time.minutes).perform_later(job.id)
        elsif nextNode.delay_unit == 2
          SendEmailJob.set(wait: node.delay_time.hours).perform_later(job.id)
        elsif nextNode.delay_unit == 3
          SendEmailJob.set(wait: node.delay_time.days).perform_later(job.id)
        end

      end
    end
  end

end