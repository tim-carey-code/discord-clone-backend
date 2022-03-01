class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:login, :register]
    
    def register
        user = User.new(user_params)
        if user.valid? && user.save
            render json: :user, status: 201
            return
        else
            render json: user.errors, status: 400
        end
    end

    def login
        email = params[:user][:email]
        password = params[:user][:password]
        user = User.find_by(email: email)
        is_valid = user && user.valid_password?(password)
        unless is_valid
            render json: {
                status: 'error',
                message: 'invalid credentials'
            }, status: 400 and return
        end 
        payload = {user_id: user.id}
        access_token = AccessToken.encode(payload)
        return render json: user, status: 200, meta: {access_token: access_token}
    end

  
    private
    
    def user_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
      )
    end
  end