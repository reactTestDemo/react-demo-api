module Api::V1
  class UsersController < ApiController
    before_action :validate_admin_user, except: [:current]

    def index
      users = current_user.admin? ? User.where.not(id: current_user.id) : User.none
      render status: 200 , json: { success: true, users: users }
    end

    def current
      user = current_user.attributes
      user.merge!(role: current_user.roles.last.try(:name))
      render status: 200 , json: { success: true, user: user }
    end

    def update
      user = User.find(params[:id])
      if user.present?
        if user_params[:password].blank? && user_params[:password_confirmation].blank?
          params[:user].delete(:password)
          params[:user].delete(:password_confirmation)
        end
        if user.update_attributes(user_params)
          render json:  { success: true, user:  user, message: 'User is updated successfully.' }
        else
          render json:  { success: false, errors: user.errors.full_messages }
        end
      else
        render json: { success: false, errors: ['User not found.'] }, status: '422'
      end
    end

    def destroy
      user = User.find_by(id: params[:id])
      if user.present?
        user.destroy
        render json: { success: true }
      else
        render json: { success: false, errors: ['User not found.'] }, status: '422'
      end
    end

    def show
      user = User.find_by(id: params[:id])
      if user.present?
        render json: { success: true, user: user.slice(:id, :email) }
      else
        render json: { success: false, errors: ['User not found.'] }, status: '422'
      end
    end

    def bulk_destroy
      User.where(id: params[:ids]).destroy_all
      render json: { success: true }
    end

    private

    def user_params
      params.require(:user).permit([ :email, :password, :password_confirmation])
    end

    def validate_admin_user
      return if current_user.admin?
      render json: { status: 401, error: 'Unauthorized' }
    end
  end
end