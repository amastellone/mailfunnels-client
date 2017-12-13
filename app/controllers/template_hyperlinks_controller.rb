class TemplateHyperlinksController < ApplicationController
  before_action :set_template_hyperlink, only: [:show, :update, :destroy]

  # GET /template_hyperlinks
  def index
    @template_hyperlinks = TemplateHyperlink.all

    render json: @template_hyperlinks
  end

  # GET /template_hyperlinks/1
  def show
    render json: @template_hyperlink
  end

  # POST /template_hyperlinks
  def create
    @template_hyperlink = TemplateHyperlink.new(template_hyperlink_params)

    if @template_hyperlink.save
      render json: @template_hyperlink, status: :created, location: @template_hyperlink
    else
      render json: @template_hyperlink.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /template_hyperlinks/1
  def update
    if @template_hyperlink.update(template_hyperlink_params)
      render json: @template_hyperlink
    else
      render json: @template_hyperlink.errors, status: :unprocessable_entity
    end
  end

  # DELETE /template_hyperlinks/1
  def destroy
    @template_hyperlink.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_template_hyperlink
      @template_hyperlink = TemplateHyperlink.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def template_hyperlink_params
      params.fetch(:template_hyperlink, {})
    end
end
