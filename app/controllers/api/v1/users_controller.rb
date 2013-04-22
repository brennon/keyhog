module Api
  module V1
    class UsersController < ApplicationController
      doorkeeper_for :all
      respond_to :json

      def show
        # puts doorkeeper_token.application.name
        @user = User.includes(:certificates).find(current_user)
        render "api/users/show"
      end

      def show_certificate
        user = User.find(current_user)
        @certificate = Certificate.find(params[:certificate_id])
        render "api/certificates/show"
      end

      private

      def current_user
        @current_user = User.find(session[:user_id]) || User.find(doorkeeper_token.resource_owner_id)
      end
    end
  end
end
