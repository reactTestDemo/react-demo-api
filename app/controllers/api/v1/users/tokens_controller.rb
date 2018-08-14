module Api::V1::Users
  class TokensController < Doorkeeper::TokensController
    def create
      response = authorize_response
      if response.class.name == 'Doorkeeper::OAuth::ErrorResponse'
        render status: '401', json: {success: false, errors: ['The email or password you entered is incorrect.']}
      else
        headers.merge! response.headers
        user = User.find_by(id: response.token.resource_owner_id)
        u= user.slice([:id, :email])
        u.merge!(role: user.roles.last.try(:name))
        user_hash = response.body.merge({token: response.body['access_token'] }).merge(u)
        self.response_body = { success: true, user: user_hash }.to_json
      end
    rescue => e
      render status: '422', json: {success: false, message: e.message}
    end
  end
end