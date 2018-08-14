Rails.application.routes.draw do
  scope :api do
    scope :v1 do
      devise_for :users, skip: [:sessions, :passwords],
                 controllers: {
                   registrations: 'api/v1/users/registrations'
                 }
      use_doorkeeper do
        controllers :tokens => 'api/v1/users/tokens'
        skip_controllers :applications, :authorized_applications, :authorizations
      end
    end
  end

  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :update, :destroy, :show, :update] do
        collection do
          get :current
          delete :bulk_destroy
        end
      end
    end
  end
end
