module Api::V1
  class ApiController < ApiApplicationController
    # Generic API stuff here
    before_action :set_headers
    before_action -> { doorkeeper_authorize! :api }

    def self.add_common_params(api)
      api.param :header, 'Authorization', :string, :required, 'Authorization token'
    end

    private

    def doorkeeper_unauthorized_render_options(error = nil)
      { json: { status: 401, error: 'Unauthorized' } }
    end

    def check_admin_user
      return true if current_user.present?  && current_user.admin?
      { json: { status: 401, error: 'Unauthorized' } }
    end

    def set_headers
      if request.headers['HTTP_AUTHORIZATION']
        token = request.headers['HTTP_AUTHORIZATION']
        token = 'Bearer ' + token if token.exclude?('Bearer ')
        request.headers['HTTP_AUTHORIZATION'] = token
      end
    end
  end
end


