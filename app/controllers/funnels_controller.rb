class FunnelsController < ApplicationController
  before_action :set_funnel, only: [:show, :update, :destroy]

  # GET /funnels
  def index
    @funnels = Funnel.all

    render json: @funnels
  end

  # GET /funnels/1
  def show
    render json: @funnel
  end

  # POST /funnels
  def create
    @funnel = Funnel.new(funnel_params)

    if @funnel.save
      render json: @funnel, status: :created, location: @funnel
    else
      render json: @funnel.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /funnels/1
  def update
    if @funnel.update(funnel_params)
      render json: @funnel
    else
      render json: @funnel.errors, status: :unprocessable_entity
    end
  end

  # DELETE /funnels/1
  def destroy
    @funnel.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_funnel
      @funnel = Funnel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def funnel_params
      params.require(:funnel).permit(:name, :description, :numTriggers, :numRevenue)
    end
end
