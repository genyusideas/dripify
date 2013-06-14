class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def new
    super
  end

  def create
    build_resource
    resource = User.new( params[:user] )
    if resource.save
      resource.ensure_authentication_token!
      render json: { authentication_token: resource.authentication_token, user_id: resource.id }, status: :created
    else
      invalid_signup_attempt
    end
  end

  def update
    super
  end

  def invalid_signup_attempt
    warden.custom_failure!
    render json: { error: ["Mismatching passwords."] }, success: false, status: 422
  end
end 