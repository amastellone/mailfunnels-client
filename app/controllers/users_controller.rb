class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]


  # POST ROUTE
  # ----------
  # Retrieves user's password and sends them an email
  # with their password
  #
  # PARAMETERS
  # ----------
  # email: Email Address of the User
  #
  def send_reset_password_email


    @user = User.where(:email => params[:email]).first

    if @user

      html = File.open("app/views/email/password_reset.html.erb").read
      @renderedhtml = "1"
      ERB.new(html, 0, "", "@renderedhtml").result(binding)

      client = Postmark::ApiClient.new('b650bfe2-d2c6-4714-aa2d-e148e1313e37', http_open_timeout: 60)
      response = client.deliver(
          :subject => "MailFunnels Password Reset",
          :to => @user.email,
          :from => 'MailFunnels noreply@custprotection.com',
          :html_body => @renderedhtml,
          :track_opens => 'true')

      response = {
          success: true,
          message: 'Your password has been sent to your email..'
      }

      render json: response

    else
      puts "final else"
      # Return Error Response
      response = {
          success: false,
          message: 'Sorry, we could not find an account with this email.'
      }

      render json: response

    end


  end



  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:username, :password, :clientid, :client_tags, :email, :street_address, :city, :state, :zip)
    end
end
