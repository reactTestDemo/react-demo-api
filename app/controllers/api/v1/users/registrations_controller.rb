class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  def create
    set_resource
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      resource.add_role(:user)
      if resource.active_for_authentication?
        initialize_doorkeeper_app
        render json: {
          success: true,
          user:  {
            email: resource.email,
            client_id: resource.try(:applications).try(:last).try(:uid),
            secret: resource.try(:applications).try(:last).try(:secret)
          }
        }
      else
        expire_data_after_sign_in!
        render json: {success: false, user: resource.name}
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      render status: '422', json: { success: false, errors: resource.errors.full_messages }
    end
  end

  protected
  def initialize_doorkeeper_app
    begin
      app_name = params[:application_name] || "Oauth-App #{resource.email}"
      object = Doorkeeper::Application.new(name: "#{app_name}", redirect_uri: request.base_url, owner: resource)
      object.save
    rescue Exception => e
      Rails.logger(e.message)
    end
  end

  private

  def set_resource
    if params[:user].nil?
      params[:user] =  {
        email: params[:email],
        password: params[:password],
        password_confirmation: params[:password_confirmation]
      }
    end
    params
  end
end
