class EmailTemplatesController < ApplicationController
  before_action :set_email_template, only: [:show, :update, :save, :destroy]

  # GET /email_templates
  def index
    @email_templates = EmailTemplate.all

    render json: @email_templates
  end

  # GET /email_templates/1
  def show
    render json: @email_template
  end

  # POST /email_templates
  def create
    @email_template = EmailTemplate.new(email_template_params)

    if @email_template.save
      render json: @email_template, status: :created, location: @email_template
    else
      render json: @email_template.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /email_templates/1
  def update
    if @email_template.update(email_template_params)
      render json: @email_template
    else
      render json: @email_template.errors, status: :unprocessable_entity
    end
  end


  # DELETE /email_templates/1
  def destroy
    @email_template.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_email_template
      @email_template = EmailTemplate.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def email_template_params
      params.require(:email_template).permit(
          :name,
          :description,
          :email_subject,
          :email_content,
          :email_title,
          :has_button,
          :button_text,
          :button_url,
          :color,
          :app_id,
          :mf_power_foot,
          :show_address,
          :greet_use_default,
          :greet_content,
          :greet_before_cust_name,
          :greet_after_cust_name,
          :email_def_color,
          :greet_use_default,
          :greet_before_cust_name,
          :greet_after_cust_name,
          :greet_content
      )
    end
end
